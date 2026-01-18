//
//  PlaybackControlUseCaseProtocol.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Combine

/// Protocol defining playback control operations
///
/// This use case manages all playback-related operations including play/pause,
/// seeking, volume control, and shuffle/repeat modes. It provides a reactive
/// stream of playback state updates via Combine.
protocol PlaybackControlUseCaseProtocol {
    /// Starts playing a track from the given Spotify URI
    ///
    /// - Parameter trackURI: Spotify track URI (e.g., "spotify:track:...")
    /// - Throws: Playback errors including network failures or invalid URIs
    func play(trackURI: String) async throws

    /// Pauses the current playback
    ///
    /// - Throws: Playback errors if the operation fails
    func pause() async throws

    /// Resumes playback from the current position
    ///
    /// - Throws: Playback errors if the operation fails
    func resume() async throws

    /// Skips to the next track in the queue
    ///
    /// - Throws: Playback errors if there is no next track or the operation fails
    func skipToNext() async throws

    /// Skips to the previous track in the queue
    ///
    /// - Throws: Playback errors if there is no previous track or the operation fails
    func skipToPrevious() async throws

    /// Seeks to a specific position in the current track
    ///
    /// - Parameter position: Target position in seconds
    /// - Throws: Playback errors if the position is invalid or the operation fails
    func seek(to position: TimeInterval) async throws

    /// Sets the playback volume
    ///
    /// - Parameter volume: Volume level (0-100)
    /// - Throws: Playback errors if the volume level is invalid or the operation fails
    func setVolume(_ volume: Int) async throws

    /// Toggles shuffle mode on/off
    ///
    /// - Throws: Playback errors if the operation fails
    func toggleShuffle() async throws

    /// Cycles through repeat modes: off → context → track → off
    ///
    /// - Throws: Playback errors if the operation fails
    func cycleRepeatMode() async throws

    /// Publisher that emits playback state updates
    ///
    /// Subscribe to this publisher to receive real-time updates about the current
    /// playback state, including track changes, position updates, and state changes.
    var playbackStatePublisher: AnyPublisher<PlaybackState, Never> { get }
}
