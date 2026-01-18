//
//  Album.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Represents a Spotify album
struct Album: Identifiable, Equatable {
    /// Unique Spotify album ID
    let id: String

    /// Album name
    let name: String

    /// List of artist names
    let artistNames: [String]

    /// Release date (ISO 8601 format: YYYY-MM-DD)
    let releaseDate: String

    /// Number of tracks in the album
    let trackCount: Int

    /// URL to album artwork image (optional)
    let imageURL: URL?

    /// Comma-separated artist names
    var artistNamesString: String {
        artistNames.joined(separator: ", ")
    }
}

extension Album {
    /// Creates a test album for preview/testing purposes
    static var preview: Album {
        Album(
            id: "test-album-123",
            name: "Test Album",
            artistNames: ["Test Artist"],
            releaseDate: "2024-01-01",
            trackCount: 12,
            imageURL: nil
        )
    }
}
