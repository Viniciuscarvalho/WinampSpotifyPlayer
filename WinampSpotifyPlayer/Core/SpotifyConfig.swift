//
//  SpotifyConfig.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Spotify application configuration
///
/// **IMPORTANT**: Before running the app, you must:
/// 1. Create a Spotify Developer Account at https://developer.spotify.com
/// 2. Register a new application
/// 3. Add `winampspotify://callback` to your app's Redirect URIs
/// 4. Copy your Client ID and Client Secret
/// 5. Update the values below (or use environment variables)
struct SpotifyConfig {
    /// Your Spotify application Client ID
    /// Get this from: https://developer.spotify.com/dashboard
    static let clientID: String = {
        // Try to read from environment first (for security)
        if let envClientID = ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_ID"] {
            return envClientID
        }

        // TODO: Replace with your actual Client ID
        // NEVER commit your actual Client ID to version control in production
        return "YOUR_CLIENT_ID_HERE"
    }()

    /// Your Spotify application Client Secret
    /// Get this from: https://developer.spotify.com/dashboard
    static let clientSecret: String = {
        // Try to read from environment first (for security)
        if let envClientSecret = ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_SECRET"] {
            return envClientSecret
        }

        // TODO: Replace with your actual Client Secret
        // NEVER commit your actual Client Secret to version control
        return "YOUR_CLIENT_SECRET_HERE"
    }()

    /// OAuth redirect URI (must match Spotify app settings exactly)
    static let redirectURI = "winampspotify://callback"
}
