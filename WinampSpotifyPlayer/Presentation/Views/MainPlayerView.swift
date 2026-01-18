//
//  MainPlayerView.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

/// Main Winamp-styled player window
struct MainPlayerView: View {
    @StateObject var viewModel: PlayerViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Title bar
                titleBar

                // Track info display
                trackInfoDisplay
                    .padding(.horizontal, 12)
                    .padding(.top, 8)

                // Album art (small)
                if let track = viewModel.currentTrack {
                    albumArtView(track: track)
                        .padding(.top, 8)
                }

                // Progress bar
                VStack(spacing: 4) {
                    ProgressBar(
                        progress: Binding(
                            get: { viewModel.position },
                            set: { _ in }
                        ),
                        onSeek: { progress in
                            viewModel.seek(to: progress)
                        }
                    )
                    .padding(.horizontal, 12)

                    // Time display
                    HStack {
                        LEDDisplay(text: viewModel.playbackState.formattedPosition)
                        Spacer()
                        LEDDisplay(text: viewModel.playbackState.formattedDuration)
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.top, 8)

                // Control buttons
                controlButtons
                    .padding(.top, 12)

                // Volume slider
                HStack {
                    Spacer()
                    VolumeSlider(
                        volume: Binding(
                            get: { viewModel.volume },
                            set: { viewModel.volume = $0 }
                        ),
                        onChange: { volume in
                            viewModel.setVolume(volume)
                        }
                    )
                    .frame(height: 80)
                    .padding(.trailing, 12)
                }
                .padding(.top, 8)

                Spacer()
            }
        }
        .frame(width: 300, height: 400)
    }

    private var titleBar: some View {
        HStack {
            Text("WINAMP")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(.green)
            Spacer()
        }
        .padding(8)
        .background(Color.black.opacity(0.9))
    }

    private var trackInfoDisplay: some View {
        VStack(spacing: 4) {
            if let track = viewModel.currentTrack {
                ScrollingLEDDisplay(text: track.name, color: .green)
                ScrollingLEDDisplay(text: track.artistNamesString, color: .gray)
            } else {
                LEDDisplay(text: "No track playing", color: .gray)
            }
        }
    }

    private func albumArtView(track: Track) -> some View {
        Group {
            if let artURL = track.albumArtURL {
                AsyncImage(url: artURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "music.note")
                            .foregroundColor(.gray)
                    )
            }
        }
        .frame(width: 100, height: 100)
        .cornerRadius(4)
    }

    private var controlButtons: some View {
        HStack(spacing: 16) {
            WinampButton(icon: "backward.fill") {
                viewModel.skipPrevious()
            }

            WinampButton(
                icon: viewModel.isPlaying ? "pause.fill" : "play.fill",
                isHighlighted: viewModel.isPlaying
            ) {
                viewModel.togglePlayPause()
            }

            WinampButton(icon: "forward.fill") {
                viewModel.skipNext()
            }

            Spacer().frame(width: 20)

            WinampButton(
                icon: "shuffle",
                isHighlighted: viewModel.isShuffleEnabled
            ) {
                viewModel.toggleShuffle()
            }

            WinampButton(
                icon: repeatModeIcon,
                isHighlighted: viewModel.repeatMode != .off
            ) {
                viewModel.cycleRepeatMode()
            }
        }
        .padding(.horizontal, 12)
    }

    private var repeatModeIcon: String {
        switch viewModel.repeatMode {
        case .off: return "repeat"
        case .context: return "repeat"
        case .track: return "repeat.1"
        }
    }
}
