//
//  SpotifyAuthUseCase.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import AuthenticationServices

/// Use case for Spotify authentication operations
final class SpotifyAuthUseCase: SpotifyAuthUseCaseProtocol {
    private let keychainRepository: KeychainRepositoryProtocol
    private let spotifyAPIRepository: SpotifyAPIRepository
    private let oauthClient: OAuthClient
    private var contextProvider: AuthenticationSessionContextProvider?

    /// Initializes the auth use case
    /// - Parameters:
    ///   - keychainRepository: Repository for secure token storage
    ///   - spotifyAPIRepository: Repository for Spotify API calls
    ///   - oauthClient: OAuth client for token exchange
    init(
        keychainRepository: KeychainRepositoryProtocol,
        spotifyAPIRepository: SpotifyAPIRepository,
        oauthClient: OAuthClient? = nil
    ) {
        self.keychainRepository = keychainRepository
        self.spotifyAPIRepository = spotifyAPIRepository

        // Use provided client or create with config
        self.oauthClient = oauthClient ?? OAuthClient(
            clientID: SpotifyConfig.clientID,
            clientSecret: SpotifyConfig.clientSecret
        )

        // Set up automatic token refresh callback using Task
        Task { [weak self, spotifyAPIRepository] in
            await spotifyAPIRepository.onTokenExpired = { @Sendable in
                guard let self = self else { return }
                try await self.refreshAccessToken()
            }
        }
    }

    // MARK: - SpotifyAuthUseCaseProtocol

    func authenticate() async throws -> User {
        // Build authorization URL
        guard let authURL = oauthClient.buildAuthorizationURL() else {
            throw APIError.invalidURL
        }

        // Present OAuth flow in browser
        let authCode = try await presentAuthenticationSession(url: authURL)

        // Exchange authorization code for tokens
        let tokenResponse = try await oauthClient.exchangeCodeForToken(authCode)

        // Store tokens in Keychain
        try await keychainRepository.save(accessToken: tokenResponse.access_token)
        if let refreshToken = tokenResponse.refresh_token {
            try await keychainRepository.save(refreshToken: refreshToken)
        }

        // Update API repository with new token
        await spotifyAPIRepository.setAccessToken(tokenResponse.access_token)

        // Fetch and return user profile
        let userDTO = try await spotifyAPIRepository.fetchUserProfile()
        return userDTO.toDomainModel()
    }

    func refreshAccessToken() async throws {
        // Get refresh token from Keychain
        guard let refreshToken = try await keychainRepository.getRefreshToken() else {
            throw APIError.unauthorized
        }

        // Request new access token
        let tokenResponse = try await oauthClient.refreshToken(refreshToken)

        // Store new access token
        try await keychainRepository.save(accessToken: tokenResponse.access_token)

        // Update new refresh token if provided
        if let newRefreshToken = tokenResponse.refresh_token {
            try await keychainRepository.save(refreshToken: newRefreshToken)
        }

        // Update API repository with new token
        await spotifyAPIRepository.setAccessToken(tokenResponse.access_token)
    }

    func logout() async throws {
        // Clear all tokens from Keychain
        try await keychainRepository.deleteTokens()

        // Clear token from API repository
        await spotifyAPIRepository.setAccessToken("")
    }

    func checkAuthentication() async -> Bool {
        do {
            let accessToken = try await keychainRepository.getAccessToken()
            let refreshToken = try await keychainRepository.getRefreshToken()
            return accessToken != nil && refreshToken != nil
        } catch {
            return false
        }
    }

    // MARK: - Private Helpers

    /// Presents the OAuth authentication session
    /// - Parameter url: Authorization URL
    /// - Returns: Authorization code from callback
    private func presentAuthenticationSession(url: URL) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            // Store context provider as instance property to keep it alive during session
            self.contextProvider = AuthenticationSessionContextProvider()

            let session = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: "winampspotify"
            ) { callbackURL, error in
                // Clean up context provider when session completes
                defer { self.contextProvider = nil }

                if let error = error {
                    // User cancelled or other error
                    if (error as NSError).code == ASWebAuthenticationSessionError.canceledLogin.rawValue {
                        continuation.resume(throwing: APIError.unauthorized)
                    } else {
                        continuation.resume(throwing: APIError.networkError(error))
                    }
                    return
                }

                guard let callbackURL = callbackURL else {
                    continuation.resume(throwing: APIError.invalidResponse)
                    return
                }

                // Extract authorization code from callback URL
                guard let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                    .queryItems?
                    .first(where: { $0.name == "code" })?
                    .value else {
                    continuation.resume(throwing: APIError.invalidResponse)
                    return
                }

                continuation.resume(returning: code)
            }

            session.presentationContextProvider = self.contextProvider
            session.prefersEphemeralWebBrowserSession = false

            if !session.start() {
                self.contextProvider = nil
                continuation.resume(throwing: APIError.invalidResponse)
            }
        }
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

/// Provides presentation context for ASWebAuthenticationSession
private final class AuthenticationSessionContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // Return the main window
        return NSApplication.shared.windows.first ?? ASPresentationAnchor()
    }
}
