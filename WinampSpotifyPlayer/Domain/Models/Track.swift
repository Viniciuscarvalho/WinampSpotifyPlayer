//
//  Track.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Represents a music track from Spotify
struct Track: Identifiable, Equatable, Sendable {
    /// Unique Spotify track ID
    let id: String

    /// Spotify URI (e.g., "spotify:track:...")
    let uri: String

    /// Track name/title
    let name: String

    /// List of artist names
    let artistNames: [String]

    /// Album name
    let albumName: String

    /// Track duration in milliseconds
    let durationMs: Int

    /// URL to album artwork image (optional)
    let albumArtURL: URL?

    /// Formatted duration string (e.g., "3:45")
    var formattedDuration: String {
        let totalSeconds = durationMs / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// Comma-separated artist names
    var artistNamesString: String {
        artistNames.joined(separator: ", ")
    }
}

extension Track {
    /// Creates a test track for preview/testing purposes
    static var preview: Track {
        Track(
            id: "test-track-123",
            uri: "spotify:track:test123",
            name: "Test Song",
            artistNames: ["Test Artist"],
            albumName: "Test Album",
            durationMs: 180000,
            albumArtURL: nil
        )
    }
}
