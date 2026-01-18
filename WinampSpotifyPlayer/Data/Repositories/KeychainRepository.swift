//
//  KeychainRepository.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Repository for secure token storage using macOS Keychain
/// Uses actor-isolated KeychainService for thread-safe access
final class KeychainRepository: KeychainRepositoryProtocol {
    private let keychainService: KeychainService

    private enum Keys {
        static let accessToken = "spotify_access_token"
        static let refreshToken = "spotify_refresh_token"
    }

    /// Initializes the repository with a Keychain service
    /// - Parameter keychainService: The Keychain service to use (defaults to new instance)
    init(keychainService: KeychainService = KeychainService()) {
        self.keychainService = keychainService
    }

    // MARK: - KeychainRepositoryProtocol

    func save(accessToken: String) async throws {
        try await keychainService.save(accessToken, for: Keys.accessToken)
    }

    func save(refreshToken: String) async throws {
        try await keychainService.save(refreshToken, for: Keys.refreshToken)
    }

    func getAccessToken() async throws -> String? {
        try await keychainService.retrieve(for: Keys.accessToken)
    }

    func getRefreshToken() async throws -> String? {
        try await keychainService.retrieve(for: Keys.refreshToken)
    }

    func deleteTokens() async throws {
        try await keychainService.delete(for: Keys.accessToken)
        try await keychainService.delete(for: Keys.refreshToken)
    }
}
