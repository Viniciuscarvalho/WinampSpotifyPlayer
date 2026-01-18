//
//  SpotifyAuthUseCaseProtocol.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Protocol defining authentication operations with Spotify
///
/// This use case handles the complete OAuth 2.0 flow including initial authentication,
/// token storage, automatic token refresh, and logout operations.
protocol SpotifyAuthUseCaseProtocol {
    /// Initiates the Spotify OAuth authentication flow
    ///
    /// Opens a browser for user login and returns the authenticated user profile.
    /// Stores access and refresh tokens securely in the Keychain.
    ///
    /// - Returns: Authenticated user information
    /// - Throws: Authentication errors including user cancellation, network failures, or invalid credentials
    func authenticate() async throws -> User

    /// Refreshes the access token using the stored refresh token
    ///
    /// Should be called automatically when API requests receive 401 Unauthorized responses.
    /// Updates the stored access token in the Keychain.
    ///
    /// - Throws: Authentication errors if refresh token is invalid or expired
    func refreshAccessToken() async throws

    /// Logs out the current user
    ///
    /// Removes all stored tokens from the Keychain and resets authentication state.
    ///
    /// - Throws: Keychain errors if token deletion fails
    func logout() async throws

    /// Indicates whether a user is currently authenticated
    ///
    /// Checks for the presence of valid access and refresh tokens.
    var isAuthenticated: Bool { get }
}
