//
//  SpotifyPlaybackRepository.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import WebKit

/// Repository for Spotify Web Playback SDK operations via WKWebView
final class SpotifyPlaybackRepository: NSObject, SpotifyPlaybackRepositoryProtocol {
    private var webView: WKWebView?
    private var accessToken: String?
    private var stateStream: AsyncStream<PlaybackStateDTO>?
    private var stateContinuation: AsyncStream<PlaybackStateDTO>.Continuation?

    override init() {
        super.init()
        setupWebView()
    }

    // MARK: - Setup

    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()

        // Add message handler for communication from JavaScript
        contentController.add(self, name: "spotifyPlayer")
        configuration.userContentController = contentController

        // Create hidden web view
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView?.navigationDelegate = self

        // Create state stream
        let (stream, continuation) = AsyncStream<PlaybackStateDTO>.makeStream()
        self.stateStream = stream
        self.stateContinuation = continuation
    }

    // MARK: - SpotifyPlaybackRepositoryProtocol

    func initializePlayer(accessToken: String) async throws {
        self.accessToken = accessToken

        // Load the HTML file with Spotify SDK
        guard let htmlPath = Bundle.main.path(forResource: "player", ofType: "html", inDirectory: "Resources/SpotifySDK"),
              let htmlString = try? String(contentsOfFile: htmlPath) else {
            throw APIError.invalidResponse
        }

        let baseURL = URL(fileURLWithPath: htmlPath).deletingLastPathComponent()

        await MainActor.run {
            webView?.loadHTMLString(htmlString, baseURL: baseURL)
        }

        // Wait a bit for SDK to load
        try await Task.sleep(nanoseconds: 2_000_000_000)

        // Initialize the player
        await evaluateJavaScript("initializePlayer('\(accessToken)')")
    }

    func play(uri: String) async throws {
        guard let accessToken = accessToken else {
            throw APIError.unauthorized
        }
        await evaluateJavaScript("play('\(uri)', '\(accessToken)')")
    }

    func pause() async throws {
        await evaluateJavaScript("pause()")
    }

    func resume() async throws {
        await evaluateJavaScript("resume()")
    }

    func seek(positionMs: Int) async throws {
        await evaluateJavaScript("seek(\(positionMs))")
    }

    func setVolume(percent: Int) async throws {
        let clampedVolume = max(0, min(100, percent))
        await evaluateJavaScript("setVolume(\(clampedVolume))")
    }

    func toggleShuffle() async throws {
        guard let accessToken = accessToken else {
            throw APIError.unauthorized
        }
        await evaluateJavaScript("toggleShuffle('\(accessToken)')")
    }

    func setRepeatMode(_ mode: RepeatMode) async throws {
        guard let accessToken = accessToken else {
            throw APIError.unauthorized
        }
        let modeInt: Int = {
            switch mode {
            case .off: return 0
            case .context: return 1
            case .track: return 2
            }
        }()
        await evaluateJavaScript("setRepeatMode(\(modeInt), '\(accessToken)')")
    }

    var playbackStateStream: AsyncStream<PlaybackStateDTO> {
        stateStream ?? AsyncStream { _ in }
    }

    // MARK: - JavaScript Evaluation

    @MainActor
    private func evaluateJavaScript(_ script: String) async {
        do {
            _ = try await webView?.evaluateJavaScript(script)
        } catch {
            print("JavaScript evaluation error: \(error)")
        }
    }
}

// MARK: - WKScriptMessageHandler

extension SpotifyPlaybackRepository: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "spotifyPlayer",
              let body = message.body as? [String: Any],
              let type = body["type"] as? String else {
            return
        }

        switch type {
        case "ready":
            print("Spotify Player Ready")

        case "state_changed":
            if let data = body["data"] as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: data),
               let stateDTO = try? JSONDecoder().decode(PlaybackStateDTO.self, from: jsonData) {
                stateContinuation?.yield(stateDTO)
            }

        case "error":
            if let data = body["data"] as? [String: Any],
               let errorMessage = data["message"] as? String {
                print("Playback error: \(errorMessage)")
            }

        default:
            break
        }
    }
}

// MARK: - WKNavigationDelegate

extension SpotifyPlaybackRepository: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView loaded")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView navigation failed: \(error)")
    }
}
