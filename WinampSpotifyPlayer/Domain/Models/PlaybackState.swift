//
//  PlaybackState.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Defines repeat mode for playback
enum RepeatMode: String, Equatable {
    /// No repeat
    case off

    /// Repeat the current track
    case track

    /// Repeat the current context (playlist/album)
    case context
}

/// Represents the current state of music playback
struct PlaybackState: Equatable {
    /// Whether music is currently playing
    let isPlaying: Bool

    /// The currently playing track (nil if no track)
    let currentTrack: Track?

    /// Current playback position in milliseconds
    let positionMs: Int

    /// Total track duration in milliseconds
    let durationMs: Int

    /// Volume level (0-100)
    let volume: Int

    /// Whether shuffle is enabled
    let shuffleState: Bool

    /// Current repeat mode
    let repeatMode: RepeatMode

    /// Progress as a percentage (0.0 to 1.0)
    var progress: Double {
        guard durationMs > 0 else { return 0.0 }
        return Double(positionMs) / Double(durationMs)
    }

    /// Formatted position time (e.g., "1:23")
    var formattedPosition: String {
        let totalSeconds = positionMs / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// Formatted duration time (e.g., "3:45")
    var formattedDuration: String {
        let totalSeconds = durationMs / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

extension PlaybackState {
    /// Creates an idle playback state (nothing playing)
    static var idle: PlaybackState {
        PlaybackState(
            isPlaying: false,
            currentTrack: nil,
            positionMs: 0,
            durationMs: 0,
            volume: 50,
            shuffleState: false,
            repeatMode: .off
        )
    }

    /// Creates a test playback state for preview/testing purposes
    static var preview: PlaybackState {
        PlaybackState(
            isPlaying: true,
            currentTrack: .preview,
            positionMs: 60000,
            durationMs: 180000,
            volume: 75,
            shuffleState: false,
            repeatMode: .off
        )
    }
}
