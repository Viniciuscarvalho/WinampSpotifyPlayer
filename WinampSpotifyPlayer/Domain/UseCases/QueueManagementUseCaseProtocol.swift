//
//  QueueManagementUseCaseProtocol.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Protocol defining queue management operations
///
/// This use case handles operations related to the playback queue, including
/// adding tracks, removing tracks, reordering, and fetching the current queue state.
protocol QueueManagementUseCaseProtocol {
    /// Adds a track to the end of the playback queue
    ///
    /// - Parameter trackURI: Spotify track URI (e.g., "spotify:track:...")
    /// - Throws: Queue errors including invalid URI or operation failures
    func addToQueue(trackURI: String) async throws

    /// Removes a track from the queue at the specified index
    ///
    /// - Parameter index: Zero-based index of the track to remove
    /// - Throws: Queue errors including invalid index or operation failures
    func removeFromQueue(at index: Int) async throws

    /// Reorders tracks in the queue by moving a track from one position to another
    ///
    /// - Parameters:
    ///   - from: Zero-based index of the track to move
    ///   - to: Zero-based index of the destination position
    /// - Throws: Queue errors including invalid indices or operation failures
    func reorderQueue(from: Int, to: Int) async throws

    /// Fetches the current playback queue
    ///
    /// Returns an ordered list of upcoming tracks in the queue.
    ///
    /// - Returns: Array of tracks in the queue
    /// - Throws: Network errors or authentication failures
    func getCurrentQueue() async throws -> [Track]
}
