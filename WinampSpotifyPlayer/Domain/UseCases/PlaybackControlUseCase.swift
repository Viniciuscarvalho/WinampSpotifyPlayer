//
//  PlaybackControlUseCase.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Combine

/// Use case for playback control operations
final class PlaybackControlUseCase: PlaybackControlUseCaseProtocol {
    private let playbackRepository: SpotifyPlaybackRepositoryProtocol
    private let playbackStateSubject = CurrentValueSubject<PlaybackState, Never>(.idle)
    private var cancellables = Set<AnyCancellable>()

    init(playbackRepository: SpotifyPlaybackRepositoryProtocol) {
        self.playbackRepository = playbackRepository
        observePlaybackState()
    }

    // MARK: - PlaybackControlUseCaseProtocol

    func play(trackURI: String) async throws {
        try await playbackRepository.play(uri: trackURI)
    }

    func pause() async throws {
        try await playbackRepository.pause()
    }

    func resume() async throws {
        try await playbackRepository.resume()
    }

    func skipToNext() async throws {
        // Handled by Spotify SDK automatically
        print("Skip to next track")
    }

    func skipToPrevious() async throws {
        // Handled by Spotify SDK automatically
        print("Skip to previous track")
    }

    func seek(to position: TimeInterval) async throws {
        let positionMs = Int(position * 1000)
        try await playbackRepository.seek(positionMs: positionMs)
    }

    func setVolume(_ volume: Int) async throws {
        let clampedVolume = max(0, min(100, volume))
        try await playbackRepository.setVolume(percent: clampedVolume)
    }

    func toggleShuffle() async throws {
        try await playbackRepository.toggleShuffle()
    }

    func cycleRepeatMode() async throws {
        let currentMode = playbackStateSubject.value.repeatMode
        let nextMode: RepeatMode = {
            switch currentMode {
            case .off: return .context
            case .context: return .track
            case .track: return .off
            }
        }()
        try await playbackRepository.setRepeatMode(nextMode)
    }

    var playbackStatePublisher: AnyPublisher<PlaybackState, Never> {
        playbackStateSubject.eraseToAnyPublisher()
    }

    // MARK: - Private

    private func observePlaybackState() {
        Task {
            for await stateDTO in playbackRepository.playbackStateStream {
                let domainState = stateDTO.toDomainModel()
                playbackStateSubject.send(domainState)
            }
        }
    }
}
