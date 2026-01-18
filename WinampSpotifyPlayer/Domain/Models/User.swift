//
//  User.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Represents a Spotify user with profile information
struct User: Sendable {
    /// Unique Spotify user ID
    let id: String

    /// User's display name
    let displayName: String

    /// User's email address (optional)
    let email: String?

    /// URL to user's profile image (optional)
    let imageURL: URL?
}

extension User {
    /// Creates a test user for preview/testing purposes
    static var preview: User {
        User(
            id: "test-user-123",
            displayName: "Test User",
            email: "test@example.com",
            imageURL: nil
        )
    }
}
