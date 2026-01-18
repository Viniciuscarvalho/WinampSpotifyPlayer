//
//  OAuthClient.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// OAuth token response from Spotify
struct OAuthTokenResponse: Decodable {
    let access_token: String
    let token_type: String
    let scope: String
    let expires_in: Int
    let refresh_token: String?
}

/// Client for Spotify OAuth 2.0 operations
final class OAuthClient {
    private let clientID: String
    private let clientSecret: String
    private let redirectURI: String

    /// Initializes the OAuth client
    /// - Parameters:
    ///   - clientID: Spotify application client ID
    ///   - clientSecret: Spotify application client secret
    ///   - redirectURI: OAuth redirect URI (must match Spotify app settings)
    init(
        clientID: String,
        clientSecret: String,
        redirectURI: String = "winampspotify://callback"
    ) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }

    // MARK: - Authorization URL

    /// Builds the Spotify authorization URL
    /// - Returns: URL for the OAuth authorization page
    func buildAuthorizationURL() -> URL? {
        let scopes = [
            "user-read-email",
            "user-read-private",
            "user-library-read",
            "user-read-playback-state",
            "user-modify-playback-state",
            "streaming",
            "playlist-read-private",
            "playlist-read-collaborative"
        ].joined(separator: " ")

        var components = URLComponents(string: "https://accounts.spotify.com/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scopes),
            URLQueryItem(name: "show_dialog", value: "true")
        ]

        return components?.url
    }

    // MARK: - Token Exchange

    /// Exchanges an authorization code for access and refresh tokens
    /// - Parameter code: Authorization code from OAuth callback
    /// - Returns: OAuth token response
    func exchangeCodeForToken(_ code: String) async throws -> OAuthTokenResponse {
        let url = URL(string: "https://accounts.spotify.com/api/token")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "client_id": clientID,
            "client_secret": clientSecret
        ]

        request.httpBody = bodyParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(OAuthTokenResponse.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Token Refresh

    /// Refreshes an access token using a refresh token
    /// - Parameter refreshToken: Valid refresh token
    /// - Returns: New OAuth token response (may include new refresh token)
    func refreshToken(_ refreshToken: String) async throws -> OAuthTokenResponse {
        let url = URL(string: "https://accounts.spotify.com/api/token")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": clientID
        ]

        request.httpBody = bodyParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized
            }
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(OAuthTokenResponse.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
