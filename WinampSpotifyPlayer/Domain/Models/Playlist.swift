//
//  Playlist.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Represents a Spotify playlist
struct Playlist: Identifiable, Equatable {
    /// Unique Spotify playlist ID
    let id: String

    /// Playlist name
    let name: String

    /// Playlist description (optional)
    let description: String?

    /// Number of tracks in the playlist
    let trackCount: Int

    /// URL to playlist cover image (optional)
    let imageURL: URL?

    /// Playlist owner username
    let owner: String
}

extension Playlist {
    /// Creates a test playlist for preview/testing purposes
    static var preview: Playlist {
        Playlist(
            id: "test-playlist-123",
            name: "My Awesome Playlist",
            description: "A collection of great songs",
            trackCount: 25,
            imageURL: nil,
            owner: "testuser"
        )
    }
}
