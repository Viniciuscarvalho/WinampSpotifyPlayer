//
//  Artist.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Represents a Spotify artist
struct Artist: Identifiable, Equatable, Sendable {
    /// Unique Spotify artist ID
    let id: String

    /// Artist name
    let name: String

    /// URL to artist image (optional)
    let imageURL: URL?

    /// List of genres associated with the artist
    let genres: [String]

    /// Comma-separated genre list
    var genresString: String {
        genres.joined(separator: ", ")
    }
}

extension Artist {
    /// Creates a test artist for preview/testing purposes
    static var preview: Artist {
        Artist(
            id: "test-artist-123",
            name: "Test Artist",
            imageURL: nil,
            genres: ["Rock", "Alternative"]
        )
    }
}
