//
//  KeychainRepositoryProtocol.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Protocol defining secure token storage operations
///
/// This repository handles secure storage and retrieval of OAuth tokens
/// using the macOS Keychain Services API with actor isolation for thread safety.
protocol KeychainRepositoryProtocol: Sendable {
    /// Saves the Spotify access token to the Keychain
    ///
    /// - Parameter accessToken: OAuth access token to store
    /// - Throws: Keychain errors if the operation fails
    func save(accessToken: String) async throws

    /// Saves the Spotify refresh token to the Keychain
    ///
    /// - Parameter refreshToken: OAuth refresh token to store
    /// - Throws: Keychain errors if the operation fails
    func save(refreshToken: String) async throws

    /// Retrieves the stored Spotify access token from the Keychain
    ///
    /// - Returns: Access token if found, nil if not present
    /// - Throws: Keychain errors if the retrieval fails
    func getAccessToken() async throws -> String?

    /// Retrieves the stored Spotify refresh token from the Keychain
    ///
    /// - Returns: Refresh token if found, nil if not present
    /// - Throws: Keychain errors if the retrieval fails
    func getRefreshToken() async throws -> String?

    /// Deletes all stored tokens from the Keychain
    ///
    /// Used during logout to clear authentication state.
    ///
    /// - Throws: Keychain errors if the deletion fails
    func deleteTokens() async throws
}
