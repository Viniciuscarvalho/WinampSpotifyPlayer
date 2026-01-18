//
//  NowPlayingInfoUpdater.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import MediaPlayer

/// Updates macOS Now Playing info for Control Center and Lock Screen
final class NowPlayingInfoUpdater {
    static let shared = NowPlayingInfoUpdater()

    private init() {}

    func updateNowPlaying(track: Track, isPlaying: Bool, position: TimeInterval) {
        var nowPlayingInfo = [String: Any]()

        nowPlayingInfo[MPMediaItemPropertyTitle] = track.name
        nowPlayingInfo[MPMediaItemPropertyArtist] = track.artistNamesString
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = track.albumName
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Double(track.durationMs) / 1000.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

        // Set album artwork if available
        if let artURL = track.albumArtURL {
            Task {
                if let artwork = await downloadArtwork(from: artURL) {
                    await MainActor.run {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                    }
                    return
                }
            }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func clearNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    private func downloadArtwork(from url: URL) async -> MPMediaItemArtwork? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = NSImage(data: data) else { return nil }

            return MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
        } catch {
            return nil
        }
    }
}
