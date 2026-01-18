//
//  SpotifyPlaybackRepositoryProtocol.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Protocol defining Spotify Web Playback SDK operations
///
/// This repository manages the WKWebView-embedded Spotify Web Playback SDK,
/// handling player initialization, playback control, and state synchronization
/// via JavaScript bridge communication.
protocol SpotifyPlaybackRepositoryProtocol {
    /// Initializes the Spotify Web Playback SDK with an access token
    ///
    /// Loads the SDK in a hidden WKWebView and establishes the JavaScript bridge
    /// for bidirectional communication.
    ///
    /// - Parameter accessToken: Valid Spotify access token
    /// - Throws: Initialization errors including SDK loading failures
    func initializePlayer(accessToken: String) async throws

    /// Plays a track from the given Spotify URI
    ///
    /// - Parameter uri: Spotify track URI (e.g., "spotify:track:...")
    /// - Throws: Playback errors including invalid URI or SDK errors
    func play(uri: String) async throws

    /// Pauses the current playback
    ///
    /// - Throws: Playback errors if the operation fails
    func pause() async throws

    /// Resumes playback from the current position
    ///
    /// - Throws: Playback errors if the operation fails
    func resume() async throws

    /// Seeks to a specific position in the current track
    ///
    /// - Parameter positionMs: Target position in milliseconds
    /// - Throws: Playback errors if the position is invalid or the operation fails
    func seek(positionMs: Int) async throws

    /// Sets the playback volume
    ///
    /// - Parameter percent: Volume level (0-100)
    /// - Throws: Playback errors if the volume level is invalid or the operation fails
    func setVolume(percent: Int) async throws

    /// Toggles shuffle mode on/off
    ///
    /// - Throws: Playback errors if the operation fails
    func toggleShuffle() async throws

    /// Sets the repeat mode
    ///
    /// - Parameter mode: Desired repeat mode (off, track, context)
    /// - Throws: Playback errors if the operation fails
    func setRepeatMode(_ mode: RepeatMode) async throws

    /// Asynchronous stream of playback state updates
    ///
    /// This stream emits new playback state DTOs whenever the player state changes,
    /// including track changes, position updates, play/pause state, etc.
    var playbackStateStream: AsyncStream<PlaybackStateDTO> { get }
}
