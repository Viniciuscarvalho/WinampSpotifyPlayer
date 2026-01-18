//
//  SpotifySDKManager.swift
//  WinampSpotifyPlayer
//
//  Spotify iOS SDK Integration Manager
//  Handles authentication and remote control via official iOS SDK
//

import Foundation
import Combine
#if os(macOS)
import AppKit
#endif

#if canImport(SpotifyiOS)
import SpotifyiOS
#endif

// Import project configuration
// Note: Ensure SpotifyConfig.swift is in the same target

/// Manager for Spotify iOS SDK integration
///
/// Provides:
/// - OAuth authentication via iOS SDK
/// - Remote control of Spotify app (if installed)
/// - Fallback to Web API/Web Playback SDK
final class SpotifySDKManager: ObservableObject {

    // MARK: - Properties

    @Published private(set) var isConnected = false
    @Published private(set) var canUseRemoteControl = false

    #if canImport(SpotifyiOS)
    private var appRemote: SPTAppRemote?
    private var sessionManager: SPTSessionManager?
    #endif

    private let configuration: SPTConfiguration

    // MARK: - Initialization

    init() {
        #if canImport(SpotifyiOS)
        // Create configuration
        self.configuration = SPTConfiguration(
            clientID: SpotifyConfig.clientID,
            redirectURL: URL(string: SpotifyConfig.redirectURI)!
        )

        // Check if Spotify app is installed
        checkSpotifyAppAvailability()
        #else
        // SDK not available, use Web API only
        self.configuration = SPTConfiguration(
            clientID: SpotifyConfig.clientID,
            redirectURL: URL(string: SpotifyConfig.redirectURI)!
        )
        #endif
    }

    // MARK: - Authentication

    /// Initiate OAuth flow using iOS SDK
    func authorize(completion: @escaping (Result<String, Error>) -> Void) {
        #if canImport(SpotifyiOS)
        guard let sessionManager = createSessionManager() else {
            completion(.failure(SpotifySDKError.sdkNotAvailable))
            return
        }

        self.sessionManager = sessionManager

        // Request authorization
        sessionManager.initiateSession(with: SPTScope.allScopes, options: .default)

        // Store completion for callback
        authCompletionHandler = completion
        #else
        // Fallback to manual OAuth if SDK not available
        completion(.failure(SpotifySDKError.sdkNotAvailable))
        #endif
    }

    #if canImport(SpotifyiOS)
    private var authCompletionHandler: ((Result<String, Error>) -> Void)?

    private func createSessionManager() -> SPTSessionManager? {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }
    #endif

    // MARK: - Remote Control

    /// Connect to Spotify app for remote control
    func connectToSpotifyApp() {
        #if canImport(SpotifyiOS)
        guard canUseRemoteControl else {
            print("⚠️ Spotify app not available for remote control")
            return
        }

        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        self.appRemote = appRemote

        appRemote.connect()
        #endif
    }

    /// Disconnect from Spotify app
    func disconnect() {
        #if canImport(SpotifyiOS)
        appRemote?.disconnect()
        #endif
    }

    // MARK: - Availability Check

    private func checkSpotifyAppAvailability() {
        #if canImport(SpotifyiOS)
        // Check if Spotify app is installed (macOS version)
        #if os(macOS)
        if let spotifyURL = URL(string: "spotify:"),
           NSWorkspace.shared.urlForApplication(toOpen: spotifyURL) != nil {
            canUseRemoteControl = true
            print("✅ Spotify app is installed - remote control available")
        } else {
            canUseRemoteControl = false
            print("ℹ️ Spotify app not installed - using Web Playback SDK only")
        }
        #else
        // iOS version
        if let spotifyURL = URL(string: "spotify:"),
           UIApplication.shared.canOpenURL(spotifyURL) {
            canUseRemoteControl = true
            print("✅ Spotify app is installed - remote control available")
        } else {
            canUseRemoteControl = false
            print("ℹ️ Spotify app not installed - using Web Playback SDK only")
        }
        #endif
        #endif
    }

    // MARK: - Playback Control (via iOS SDK)

    /// Play a track using remote control
    func playTrack(uri: String) {
        #if canImport(SpotifyiOS)
        guard isConnected, let appRemote = appRemote else {
            print("⚠️ Not connected to Spotify app")
            return
        }

        appRemote.playerAPI?.play(uri) { result, error in
            if let error = error {
                print("❌ Error playing track: \(error)")
            } else {
                print("✅ Playing track via remote control: \(uri)")
            }
        }
        #endif
    }

    func pause() {
        #if canImport(SpotifyiOS)
        appRemote?.playerAPI?.pause { result, error in
            if let error = error {
                print("❌ Error pausing: \(error)")
            }
        }
        #endif
    }

    func resume() {
        #if canImport(SpotifyiOS)
        appRemote?.playerAPI?.resume { result, error in
            if let error = error {
                print("❌ Error resuming: \(error)")
            }
        }
        #endif
    }

    func skipToNext() {
        #if canImport(SpotifyiOS)
        appRemote?.playerAPI?.skip(toNext: { result, error in
            if let error = error {
                print("❌ Error skipping: \(error)")
            }
        })
        #endif
    }

    func skipToPrevious() {
        #if canImport(SpotifyiOS)
        appRemote?.playerAPI?.skip(toPrevious: { result, error in
            if let error = error {
                print("❌ Error skipping: \(error)")
            }
        })
        #endif
    }
}

// MARK: - SPTSessionManagerDelegate

#if canImport(SpotifyiOS)
extension SpotifySDKManager: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("✅ Session initiated successfully")
        authCompletionHandler?(.success(session.accessToken))
        authCompletionHandler = nil
    }

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("❌ Session failed: \(error)")
        authCompletionHandler?(.failure(error))
        authCompletionHandler = nil
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("✅ Session renewed")
    }
}
#endif

// MARK: - SPTAppRemoteDelegate

#if canImport(SpotifyiOS)
extension SpotifySDKManager: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("✅ Connected to Spotify app for remote control")
        isConnected = true

        // Subscribe to player state
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe { result, error in
            if let error = error {
                print("❌ Error subscribing to player state: \(error)")
            }
        }
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("❌ Failed to connect to Spotify app: \(error?.localizedDescription ?? "Unknown")")
        isConnected = false
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("ℹ️ Disconnected from Spotify app")
        isConnected = false
    }
}
#endif

// MARK: - SPTAppRemotePlayerStateDelegate

#if canImport(SpotifyiOS)
extension SpotifySDKManager: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("🎵 Player state changed:")
        print("  Track: \(playerState.track.name)")
        print("  Artist: \(playerState.track.artist.name)")
        print("  Is paused: \(playerState.isPaused)")
    }
}
#endif

// MARK: - Configuration Extension

struct SPTConfiguration {
    let clientID: String
    let redirectURL: URL
}

#if canImport(SpotifyiOS)
extension SPTScope {
    static var allScopes: [SPTScope] {
        return [
            .userReadPrivate,
            .userReadEmail,
            .playlistReadPrivate,
            .playlistReadCollaborative,
            .userLibraryRead,
            .userReadPlaybackState,
            .userModifyPlaybackState,
            .userReadCurrentlyPlaying,
            .streaming,
            .appRemoteControl
        ]
    }
}
#endif

// MARK: - Errors

enum SpotifySDKError: Error {
    case sdkNotAvailable
    case notConnected
    case authenticationFailed

    var localizedDescription: String {
        switch self {
        case .sdkNotAvailable:
            return "Spotify iOS SDK is not available. Using Web API instead."
        case .notConnected:
            return "Not connected to Spotify app."
        case .authenticationFailed:
            return "Authentication failed."
        }
    }
}
