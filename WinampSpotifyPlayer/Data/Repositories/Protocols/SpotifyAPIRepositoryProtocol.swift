//
//  SpotifyAPIRepositoryProtocol.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Protocol defining Spotify Web API operations
///
/// This repository handles all HTTP requests to the Spotify Web API for fetching
/// metadata including playlists, tracks, albums, artists, and user profile information.
protocol SpotifyAPIRepositoryProtocol {
    /// Fetches the current user's playlists
    ///
    /// - Returns: Array of playlist DTOs
    /// - Throws: Network errors or API failures
    func fetchPlaylists() async throws -> [PlaylistDTO]

    /// Fetches tracks for a specific playlist
    ///
    /// - Parameter playlistID: Spotify playlist ID
    /// - Returns: Array of track DTOs
    /// - Throws: Network errors, API failures, or invalid playlist ID
    func fetchTracks(for playlistID: String) async throws -> [TrackDTO]

    /// Fetches the current user's profile information
    ///
    /// - Returns: User profile DTO
    /// - Throws: Network errors or API failures
    func fetchUserProfile() async throws -> UserDTO

    /// Fetches the user's saved (liked) tracks
    ///
    /// - Parameters:
    ///   - limit: Number of tracks to fetch per request (max 50)
    ///   - offset: Offset for pagination
    /// - Returns: Array of track DTOs
    /// - Throws: Network errors or API failures
    func fetchSavedTracks(limit: Int, offset: Int) async throws -> [TrackDTO]

    /// Fetches the user's saved albums
    ///
    /// - Parameters:
    ///   - limit: Number of albums to fetch per request (max 50)
    ///   - offset: Offset for pagination
    /// - Returns: Array of album DTOs
    /// - Throws: Network errors or API failures
    func fetchSavedAlbums(limit: Int, offset: Int) async throws -> [AlbumDTO]

    /// Fetches artists followed by the user
    ///
    /// - Parameters:
    ///   - limit: Number of artists to fetch per request (max 50)
    ///   - after: Cursor for pagination
    /// - Returns: Array of artist DTOs
    /// - Throws: Network errors or API failures
    func fetchFollowedArtists(limit: Int, after: String?) async throws -> [ArtistDTO]
}
