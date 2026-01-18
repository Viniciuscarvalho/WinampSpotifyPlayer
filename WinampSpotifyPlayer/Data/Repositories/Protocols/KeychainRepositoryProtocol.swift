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
/// using the macOS Keychain Services API.
protocol KeychainRepositoryProtocol {
    /// Saves the Spotify access token to the Keychain
    ///
    /// - Parameter accessToken: OAuth access token to store
    /// - Throws: Keychain errors if the operation fails
    func save(accessToken: String) throws

    /// Saves the Spotify refresh token to the Keychain
    ///
    /// - Parameter refreshToken: OAuth refresh token to store
    /// - Throws: Keychain errors if the operation fails
    func save(refreshToken: String) throws

    /// Retrieves the stored Spotify access token from the Keychain
    ///
    /// - Returns: Access token if found, nil if not present
    /// - Throws: Keychain errors if the retrieval fails
    func getAccessToken() throws -> String?

    /// Retrieves the stored Spotify refresh token from the Keychain
    ///
    /// - Returns: Refresh token if found, nil if not present
    /// - Throws: Keychain errors if the retrieval fails
    func getRefreshToken() throws -> String?

    /// Deletes all stored tokens from the Keychain
    ///
    /// Used during logout to clear authentication state.
    ///
    /// - Throws: Keychain errors if the deletion fails
    func deleteTokens() throws
}
