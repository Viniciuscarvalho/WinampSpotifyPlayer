//
//  LibraryManagementUseCase.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Use case for library and playlist management operations
final class LibraryManagementUseCase: LibraryManagementUseCaseProtocol {
    private let apiRepository: SpotifyAPIRepositoryProtocol

    init(apiRepository: SpotifyAPIRepositoryProtocol) {
        self.apiRepository = apiRepository
    }

    // MARK: - LibraryManagementUseCaseProtocol

    func fetchUserPlaylists() async throws -> [Playlist] {
        let playlistDTOs = try await apiRepository.fetchPlaylists()
        return playlistDTOs.map { $0.toDomainModel() }
    }

    func fetchPlaylistTracks(playlistID: String) async throws -> [Track] {
        let trackDTOs = try await apiRepository.fetchTracks(for: playlistID)
        return trackDTOs.map { $0.toDomainModel() }
    }

    func fetchSavedTracks() async throws -> [Track] {
        var allTracks: [Track] = []
        var offset = 0
        let limit = 50

        while true {
            let trackDTOs = try await apiRepository.fetchSavedTracks(limit: limit, offset: offset)
            if trackDTOs.isEmpty {
                break
            }
            allTracks.append(contentsOf: trackDTOs.map { $0.toDomainModel() })
            offset += limit

            // Safety limit to prevent infinite loops
            if offset > 10000 {
                break
            }
        }

        return allTracks
    }

    func fetchSavedAlbums() async throws -> [Album] {
        var allAlbums: [Album] = []
        var offset = 0
        let limit = 50

        while true {
            let albumDTOs = try await apiRepository.fetchSavedAlbums(limit: limit, offset: offset)
            if albumDTOs.isEmpty {
                break
            }
            allAlbums.append(contentsOf: albumDTOs.map { $0.toDomainModel() })
            offset += limit

            // Safety limit
            if offset > 10000 {
                break
            }
        }

        return allAlbums
    }

    func fetchFollowedArtists() async throws -> [Artist] {
        var allArtists: [Artist] = []
        var after: String? = nil
        let limit = 50

        while true {
            let artistDTOs = try await apiRepository.fetchFollowedArtists(limit: limit, after: after)
            if artistDTOs.isEmpty {
                break
            }
            allArtists.append(contentsOf: artistDTOs.map { $0.toDomainModel() })

            // Get cursor for next page (would need to be added to response)
            // For now, just fetch one page
            break
        }

        return allArtists
    }
}
