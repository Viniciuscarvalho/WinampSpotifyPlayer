//
//  PlayerViewModel.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Combine

/// View model for the main player interface
@MainActor
final class PlayerViewModel: ObservableObject {
    @Published var playbackState: PlaybackState = .idle
    @Published var currentTrack: Track?
    @Published var isPlaying = false
    @Published var position: Double = 0.0 // 0.0 to 1.0
    @Published var volume: Double = 0.5
    @Published var isShuffleEnabled = false
    @Published var repeatMode: RepeatMode = .off

    private let playbackUseCase: PlaybackControlUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(playbackUseCase: PlaybackControlUseCaseProtocol) {
        self.playbackUseCase = playbackUseCase
        observePlaybackState()
    }

    // MARK: - Playback Controls

    func play(track: Track) {
        Task {
            do {
                try await playbackUseCase.play(trackURI: track.uri)
            } catch {
                print("Play error: \(error)")
            }
        }
    }

    func togglePlayPause() {
        Task {
            do {
                if isPlaying {
                    try await playbackUseCase.pause()
                } else {
                    try await playbackUseCase.resume()
                }
            } catch {
                print("Play/pause error: \(error)")
            }
        }
    }

    func skipNext() {
        Task {
            do {
                try await playbackUseCase.skipToNext()
            } catch {
                print("Skip next error: \(error)")
            }
        }
    }

    func skipPrevious() {
        Task {
            do {
                try await playbackUseCase.skipToPrevious()
            } catch {
                print("Skip previous error: \(error)")
            }
        }
    }

    func seek(to progress: Double) {
        guard let duration = currentTrack?.durationMs else { return }
        let positionSeconds = Double(duration) / 1000.0 * progress

        Task {
            do {
                try await playbackUseCase.seek(to: positionSeconds)
            } catch {
                print("Seek error: \(error)")
            }
        }
    }

    func setVolume(_ volume: Double) {
        let volumePercent = Int(volume * 100)
        Task {
            do {
                try await playbackUseCase.setVolume(volumePercent)
            } catch {
                print("Volume error: \(error)")
            }
        }
    }

    func toggleShuffle() {
        Task {
            do {
                try await playbackUseCase.toggleShuffle()
            } catch {
                print("Shuffle error: \(error)")
            }
        }
    }

    func cycleRepeatMode() {
        Task {
            do {
                try await playbackUseCase.cycleRepeatMode()
            } catch {
                print("Repeat mode error: \(error)")
            }
        }
    }

    // MARK: - Private

    private func observePlaybackState() {
        playbackUseCase.playbackStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.playbackState = state
                self?.currentTrack = state.currentTrack
                self?.isPlaying = state.isPlaying
                self?.isShuffleEnabled = state.shuffleState
                self?.repeatMode = state.repeatMode

                if state.durationMs > 0 {
                    self?.position = Double(state.positionMs) / Double(state.durationMs)
                }
            }
            .store(in: &cancellables)
    }
}
