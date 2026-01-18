//
//  SpotifyAPIRepository.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Repository for Spotify Web API operations with actor isolation
actor SpotifyAPIRepository: SpotifyAPIRepositoryProtocol {
    private let httpClient: HTTPClientProtocol
    private var accessToken: String?

    /// Token refresh callback - called when 401 is encountered
    /// Uses @Sendable to ensure thread safety across actor boundaries
    var onTokenExpired: (@Sendable () async throws -> Void)?

    /// Initializes the repository
    /// - Parameter httpClient: HTTP client to use for requests
    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.httpClient = httpClient
    }

    /// Sets the access token for API requests
    /// - Parameter token: Spotify access token
    func setAccessToken(_ token: String) {
        self.accessToken = token
    }

    // MARK: - Private Helpers

    /// Makes an authenticated request with automatic retry on token expiration
    private func authenticatedRequest<T: Decodable & Sendable>(
        _ endpoint: String,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        guard let token = accessToken else {
            throw APIError.unauthorized
        }

        let headers = ["Authorization": "Bearer \(token)"]

        do {
            return try await httpClient.request(
                endpoint,
                method: .get,
                headers: headers,
                queryItems: queryItems
            )
        } catch APIError.unauthorized {
            // Token expired - try to refresh and retry once
            try await onTokenExpired?()
            guard let newToken = accessToken else {
                throw APIError.unauthorized
            }
            let newHeaders = ["Authorization": "Bearer \(newToken)"]
            return try await httpClient.request(
                endpoint,
                method: .get,
                headers: newHeaders,
                queryItems: queryItems
            )
        }
    }

    // MARK: - Response DTOs with Pagination

    private struct PaginatedResponse<T: Decodable & Sendable>: Decodable, Sendable {
        let items: [T]
        let next: String?
        let total: Int
    }

    private struct PlaylistTracksResponse: Decodable, Sendable {
        let items: [PlaylistTrackItem]
        let next: String?
        let total: Int

        struct PlaylistTrackItem: Decodable, Sendable {
            let track: TrackDTO?
        }
    }

    private struct SavedTracksResponse: Decodable, Sendable {
        let items: [SavedTrackItem]
        let next: String?
        let total: Int

        struct SavedTrackItem: Decodable, Sendable {
            let track: TrackDTO
        }
    }

    private struct SavedAlbumsResponse: Decodable, Sendable {
        let items: [SavedAlbumItem]
        let next: String?
        let total: Int

        struct SavedAlbumItem: Decodable, Sendable {
            let album: AlbumDTO
        }
    }

    private struct FollowedArtistsResponse: Decodable, Sendable {
        let artists: ArtistsCursor

        struct ArtistsCursor: Decodable, Sendable {
            let items: [ArtistDTO]
            let next: String?
        }
    }

    // MARK: - SpotifyAPIRepositoryProtocol

    func fetchUserProfile() async throws -> UserDTO {
        try await authenticatedRequest("/me")
    }

    func fetchPlaylists() async throws -> [PlaylistDTO] {
        var allPlaylists: [PlaylistDTO] = []
        var nextURL: String? = "/me/playlists"

        while let url = nextURL {
            let queryItems = [
                URLQueryItem(name: "limit", value: "50")
            ]

            let response: PaginatedResponse<PlaylistDTO> = try await authenticatedRequest(
                url.hasPrefix("/") ? url : extractPath(from: url),
                queryItems: url.hasPrefix("/") ? queryItems : nil
            )

            allPlaylists.append(contentsOf: response.items)
            nextURL = response.next
        }

        return allPlaylists
    }

    func fetchTracks(for playlistID: String) async throws -> [TrackDTO] {
        var allTracks: [TrackDTO] = []
        var nextURL: String? = "/playlists/\(playlistID)/tracks"

        while let url = nextURL {
            let queryItems = [
                URLQueryItem(name: "limit", value: "100")
            ]

            let response: PlaylistTracksResponse = try await authenticatedRequest(
                url.hasPrefix("/") ? url : extractPath(from: url),
                queryItems: url.hasPrefix("/") ? queryItems : nil
            )

            // Filter out nil tracks (can happen with deleted tracks)
            let validTracks = response.items.compactMap { $0.track }
            allTracks.append(contentsOf: validTracks)
            nextURL = response.next
        }

        return allTracks
    }

    func fetchSavedTracks(limit: Int = 50, offset: Int = 0) async throws -> [TrackDTO] {
        let queryItems = [
            URLQueryItem(name: "limit", value: "\(min(limit, 50))"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]

        let response: SavedTracksResponse = try await authenticatedRequest(
            "/me/tracks",
            queryItems: queryItems
        )

        return response.items.map { $0.track }
    }

    func fetchSavedAlbums(limit: Int = 50, offset: Int = 0) async throws -> [AlbumDTO] {
        let queryItems = [
            URLQueryItem(name: "limit", value: "\(min(limit, 50))"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]

        let response: SavedAlbumsResponse = try await authenticatedRequest(
            "/me/albums",
            queryItems: queryItems
        )

        return response.items.map { $0.album }
    }

    func fetchFollowedArtists(limit: Int = 50, after: String? = nil) async throws -> [ArtistDTO] {
        var queryItems = [
            URLQueryItem(name: "type", value: "artist"),
            URLQueryItem(name: "limit", value: "\(min(limit, 50))")
        ]

        if let after = after {
            queryItems.append(URLQueryItem(name: "after", value: after))
        }

        let response: FollowedArtistsResponse = try await authenticatedRequest(
            "/me/following",
            queryItems: queryItems
        )

        return response.artists.items
    }

    // MARK: - Helpers

    /// Extracts the path component from a full URL
    private func extractPath(from url: String) -> String {
        guard let components = URLComponents(string: url),
              let path = components.path as String? else {
            return url
        }

        var result = path
        if let query = components.query {
            result += "?" + query
        }
        return result
    }
}
