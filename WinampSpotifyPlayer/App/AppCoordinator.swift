//
//  AppCoordinator.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import SwiftUI

/// Coordinates app-level dependencies and initialization
@MainActor
final class AppCoordinator: ObservableObject {
    // Repositories
    let keychainRepository: KeychainRepositoryProtocol
    let spotifyAPIRepository: SpotifyAPIRepository
    let spotifyPlaybackRepository: SpotifyPlaybackRepositoryProtocol

    // Use Cases
    let authUseCase: SpotifyAuthUseCaseProtocol
    let playbackUseCase: PlaybackControlUseCaseProtocol
    let libraryUseCase: LibraryManagementUseCaseProtocol
    let queueUseCase: QueueManagementUseCaseProtocol

    // View Models
    let authViewModel: AuthViewModel
    let playerViewModel: PlayerViewModel
    let libraryViewModel: LibraryViewModel

    // Services
    let mediaKeyHandler: MediaKeyHandler
    let menuBarManager: MenuBarManager

    @Published var isAuthenticated = false

    init() {
        // Initialize repositories
        keychainRepository = KeychainRepository()
        spotifyAPIRepository = SpotifyAPIRepository()
        spotifyPlaybackRepository = SpotifyPlaybackRepository()

        // Initialize use cases
        authUseCase = SpotifyAuthUseCase(
            keychainRepository: keychainRepository,
            spotifyAPIRepository: spotifyAPIRepository
        )

        playbackUseCase = PlaybackControlUseCase(
            playbackRepository: spotifyPlaybackRepository
        )

        libraryUseCase = LibraryManagementUseCase(
            apiRepository: spotifyAPIRepository
        )

        queueUseCase = QueueManagementUseCase()

        // Initialize view models
        authViewModel = AuthViewModel(authUseCase: authUseCase)
        playerViewModel = PlayerViewModel(playbackUseCase: playbackUseCase)
        libraryViewModel = LibraryViewModel(libraryUseCase: libraryUseCase)

        // Initialize services
        mediaKeyHandler = MediaKeyHandler()
        menuBarManager = MenuBarManager()

        // Setup
        setupObservers()
        setupMediaKeys()
        setupMenuBar()
    }

    private func setupObservers() {
        // Observe auth state
        authViewModel.$isAuthenticated
            .assign(to: &$isAuthenticated)

        // Observe track changes for notifications
        playerViewModel.$currentTrack
            .compactMap { $0 }
            .sink { track in
                NotificationManager.shared.showNowPlaying(track: track)
                NowPlayingInfoUpdater.shared.updateNowPlaying(
                    track: track,
                    isPlaying: self.playerViewModel.isPlaying,
                    position: self.playerViewModel.position
                )
            }
            .store(in: &cancellables)
    }

    private func setupMediaKeys() {
        mediaKeyHandler.onPlayPause = { [weak self] in
            self?.playerViewModel.togglePlayPause()
        }

        mediaKeyHandler.onNext = { [weak self] in
            self?.playerViewModel.skipNext()
        }

        mediaKeyHandler.onPrevious = { [weak self] in
            self?.playerViewModel.skipPrevious()
        }

        mediaKeyHandler.startMonitoring()
    }

    private func setupMenuBar() {
        menuBarManager.setup(playerViewModel: playerViewModel)
    }

    private var cancellables = Set<AnyCancellable>()
}

import Combine
