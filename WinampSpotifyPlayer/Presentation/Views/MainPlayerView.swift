//
//  MainPlayerView.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

/// Main Winamp-styled player window - Recreates classic Winamp interface
struct MainPlayerView: View {
    @StateObject var viewModel: PlayerViewModel
    @State private var showVisualizer = false

    var body: some View {
        ZStack {
            // Winamp's signature dark gray background
            Color(red: 0.16, green: 0.16, blue: 0.16)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Title bar with classic Winamp styling
                titleBar

                // Main player area
                mainPlayerArea

                // Control buttons section
                controlButtonsSection

                // Bottom info bar
                bottomInfoBar
            }
        }
        .frame(width: 275, height: 116)
    }

    // MARK: - Title Bar

    private var titleBar: some View {
        HStack(spacing: 4) {
            Text("WINAMP")
                .font(.system(size: 9, weight: .bold, design: .monospaced))
                .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))
                .padding(.leading, 6)

            Spacer()

            // Window control buttons (minimize, maximize, close)
            HStack(spacing: 2) {
                Circle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 8, height: 8)
            }
            .padding(.trailing, 6)
        }
        .frame(height: 14)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.25, blue: 0.35),
                    Color(red: 0.15, green: 0.15, blue: 0.25)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Main Player Area

    private var mainPlayerArea: some View {
        HStack(spacing: 0) {
            // Left section: Track info and visualizer
            VStack(spacing: 2) {
                // Clutterbar - shows bitrate, khz, stereo/mono
                clutterbar
                    .frame(height: 12)

                // Main display - scrolling track name
                trackNameDisplay
                    .frame(height: 16)

                // Visualizer area
                visualizerArea
                    .frame(height: 32)
            }
            .frame(width: 155)
            .padding(.leading, 10)

            Spacer()

            // Right section: Time display and volume
            VStack(spacing: 4) {
                // Time display
                timeDisplay
                    .frame(width: 70, height: 16)

                // Volume slider (vertical)
                volumeControl
                    .frame(width: 14, height: 52)
            }
            .padding(.trailing, 10)
            .padding(.top, 14)
        }
        .frame(height: 70)
    }

    private var clutterbar: some View {
        HStack(spacing: 8) {
            // Bitrate display (simulated)
            Text("320")
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))

            // Frequency display
            Text("44")
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))

            // Stereo indicator
            Text("STEREO")
                .font(.system(size: 6, weight: .bold, design: .monospaced))
                .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))

            Spacer()
        }
        .padding(.horizontal, 4)
        .background(Color.black)
    }

    private var trackNameDisplay: some View {
        HStack(spacing: 0) {
            if let track = viewModel.currentTrack {
                ScrollingText(
                    text: "\(viewModel.isPlaying ? "▶" : "■") \(track.name) - \(track.artistNamesString)",
                    color: Color(red: 0.0, green: 1.0, blue: 0.0)
                )
            } else {
                Text("Winamp ***")
                    .font(.system(size: 9, weight: .regular, design: .monospaced))
                    .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 4)
        .background(Color.black)
    }

    private var visualizerArea: some View {
        // Simulated visualizer bars
        HStack(spacing: 1) {
            ForEach(0..<20, id: \.self) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.0, green: 0.8, blue: 0.0),
                                Color(red: 0.0, green: 0.4, blue: 0.0)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 3, height: CGFloat.random(in: 4...28))
                    .opacity(viewModel.isPlaying ? 0.9 : 0.2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }

    private var timeDisplay: some View {
        HStack(spacing: 2) {
            Text(viewModel.playbackState.formattedPosition)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .overlay(
            Rectangle()
                .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 1)
        )
    }

    private var volumeControl: some View {
        // Vertical volume slider styled like Winamp
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background track
                Rectangle()
                    .fill(Color.black)

                // Volume level indicator
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.0, green: 0.8, blue: 0.0),
                                Color(red: 0.0, green: 0.5, blue: 0.0)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(height: geometry.size.height * CGFloat(viewModel.volume))
            }
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 1)
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let newVolume = 1.0 - Double(value.location.y / geometry.size.height)
                        let clampedVolume = max(0.0, min(1.0, newVolume))
                        viewModel.setVolume(clampedVolume)
                    }
            )
        }
    }

    // MARK: - Control Buttons Section

    private var controlButtonsSection: some View {
        HStack(spacing: 0) {
            // Left side buttons
            HStack(spacing: 2) {
                // Previous button
                winampControlButton(icon: "⏮", width: 23) {
                    viewModel.skipPrevious()
                }

                // Play button
                winampControlButton(icon: "▶", width: 23, isHighlighted: viewModel.isPlaying) {
                    viewModel.togglePlayPause()
                }

                // Pause button
                winampControlButton(icon: "⏸", width: 23) {
                    viewModel.togglePlayPause()
                }

                // Stop button
                winampControlButton(icon: "■", width: 23) {
                    viewModel.stop()
                }

                // Next button
                winampControlButton(icon: "⏭", width: 23) {
                    viewModel.skipNext()
                }
            }
            .padding(.leading, 16)

            Spacer()

            // Right side buttons
            HStack(spacing: 2) {
                // Open file (playlist)
                winampControlButton(icon: "📂", width: 22) {
                    // Open playlist window
                }

                // Menu button
                winampControlButton(icon: "☰", width: 22) {
                    // Show menu
                }
            }
            .padding(.trailing, 16)
        }
        .frame(height: 18)
        .background(Color(red: 0.16, green: 0.16, blue: 0.16))
    }

    // MARK: - Bottom Info Bar

    private var bottomInfoBar: some View {
        HStack(spacing: 0) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color(red: 0.12, green: 0.12, blue: 0.12))

                    // Progress indicator
                    Rectangle()
                        .fill(Color(red: 0.0, green: 0.7, blue: 0.0))
                        .frame(width: geometry.size.width * CGFloat(viewModel.position))
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let progress = Double(value.location.x / geometry.size.width)
                            viewModel.seek(to: max(0, min(1, progress)))
                        }
                )
            }
            .frame(height: 10)
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 1)
            )
            .padding(.leading, 10)

            // Mode indicators
            HStack(spacing: 4) {
                // Shuffle indicator
                Text("S")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(viewModel.isShuffleEnabled ? Color.green : Color.gray)
                    .frame(width: 12, height: 10)
                    .background(Color.black)
                    .onTapGesture {
                        viewModel.toggleShuffle()
                    }

                // Repeat indicator
                Text("R")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(viewModel.repeatMode != .off ? Color.green : Color.gray)
                    .frame(width: 12, height: 10)
                    .background(Color.black)
                    .onTapGesture {
                        viewModel.cycleRepeatMode()
                    }
            }
            .padding(.horizontal, 6)
        }
        .frame(height: 14)
        .background(Color(red: 0.16, green: 0.16, blue: 0.16))
    }

    // MARK: - Helper Views

    private func winampControlButton(icon: String, width: CGFloat, isHighlighted: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(icon)
                .font(.system(size: 10))
                .foregroundColor(isHighlighted ? Color.green : Color.white)
                .frame(width: width, height: 18)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.35, green: 0.35, blue: 0.35),
                            Color(red: 0.25, green: 0.25, blue: 0.25)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Rectangle()
                        .stroke(Color(red: 0.4, green: 0.4, blue: 0.4), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Scrolling Text Component

struct ScrollingText: View {
    let text: String
    let color: Color
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .font(.system(size: 9, weight: .regular, design: .monospaced))
                .foregroundColor(color)
                .offset(x: offset)
                .onAppear {
                    let textWidth = text.count * 6 // Approximate width
                    if textWidth > Int(geometry.size.width) {
                        withAnimation(
                            Animation.linear(duration: Double(text.count) * 0.2)
                                .repeatForever(autoreverses: false)
                        ) {
                            offset = -CGFloat(textWidth)
                        }
                    }
                }
        }
    }
}

// MARK: - PlayerViewModel Extension

extension PlayerViewModel {
    func stop() {
        // Stop playback (pause and reset to beginning)
        if isPlaying {
            togglePlayPause()
        }
    }
}
