//
//  LibraryManagementUseCaseProtocol.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Protocol defining library and playlist management operations
///
/// This use case handles fetching and browsing the user's Spotify library,
/// including playlists, saved tracks, albums, and followed artists.
protocol LibraryManagementUseCaseProtocol {
    /// Fetches all playlists for the current user
    ///
    /// Retrieves both owned and followed playlists, automatically handling pagination.
    ///
    /// - Returns: Array of user playlists
    /// - Throws: Network errors or authentication failures
    func fetchUserPlaylists() async throws -> [Playlist]

    /// Fetches all tracks in a specific playlist
    ///
    /// - Parameter playlistID: Spotify playlist ID
    /// - Returns: Array of tracks in the playlist
    /// - Throws: Network errors, authentication failures, or invalid playlist ID
    func fetchPlaylistTracks(playlistID: String) async throws -> [Track]

    /// Fetches the user's saved (liked) tracks
    ///
    /// Automatically handles pagination to retrieve all saved tracks.
    ///
    /// - Returns: Array of saved tracks
    /// - Throws: Network errors or authentication failures
    func fetchSavedTracks() async throws -> [Track]

    /// Fetches the user's saved albums
    ///
    /// Automatically handles pagination to retrieve all saved albums.
    ///
    /// - Returns: Array of saved albums
    /// - Throws: Network errors or authentication failures
    func fetchSavedAlbums() async throws -> [Album]

    /// Fetches artists followed by the user
    ///
    /// Automatically handles pagination to retrieve all followed artists.
    ///
    /// - Returns: Array of followed artists
    /// - Throws: Network errors or authentication failures
    func fetchFollowedArtists() async throws -> [Artist]
}
