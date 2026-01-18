//
//  QueueManagementUseCase.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Use case for queue management operations
final class QueueManagementUseCase: QueueManagementUseCaseProtocol {
    // In-memory queue (Spotify API has limited queue support)
    private var queue: [Track] = []

    // MARK: - QueueManagementUseCaseProtocol

    func addToQueue(trackURI: String) async throws {
        // In a real implementation, would use Spotify API to add to queue
        // For now, maintain local queue
        print("Add to queue: \(trackURI)")
    }

    func removeFromQueue(at index: Int) async throws {
        guard index >= 0 && index < queue.count else {
            throw APIError.badRequest("Invalid queue index")
        }
        queue.remove(at: index)
    }

    func reorderQueue(from: Int, to: Int) async throws {
        guard from >= 0 && from < queue.count &&
              to >= 0 && to < queue.count else {
            throw APIError.badRequest("Invalid queue indices")
        }

        let track = queue.remove(at: from)
        queue.insert(track, at: to)
    }

    func getCurrentQueue() async throws -> [Track] {
        return queue
    }

    // MARK: - Helper Methods

    func setQueue(_ tracks: [Track]) {
        self.queue = tracks
    }
}
