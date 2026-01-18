//
//  LibraryViewModel.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Combine

/// View model for library and playlist browsing
@MainActor
final class LibraryViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var selectedPlaylist: Playlist?
    @Published var playlistTracks: [Track] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let libraryUseCase: LibraryManagementUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(libraryUseCase: LibraryManagementUseCaseProtocol) {
        self.libraryUseCase = libraryUseCase
    }

    func loadPlaylists() {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                playlists = try await libraryUseCase.fetchUserPlaylists()
            } catch {
                errorMessage = "Failed to load playlists: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }

    func loadTracks(for playlist: Playlist) {
        Task {
            isLoading = true
            errorMessage = nil
            selectedPlaylist = playlist

            do {
                playlistTracks = try await libraryUseCase.fetchPlaylistTracks(playlistID: playlist.id)
            } catch {
                errorMessage = "Failed to load tracks: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }
}
