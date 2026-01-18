//
//  PlaylistWindowView.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

/// Playlist and library browser window
struct PlaylistWindowView: View {
    @StateObject var viewModel: LibraryViewModel
    @ObservedObject var playerViewModel: PlayerViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            HSplitView {
                // Playlist list
                playlistList
                    .frame(minWidth: 200, maxWidth: 300)

                // Track list
                trackList
                    .frame(minWidth: 400)
            }
        }
        .frame(width: 700, height: 500)
        .onAppear {
            viewModel.loadPlaylists()
        }
    }

    private var playlistList: some View {
        VStack(spacing: 0) {
            // Header
            Text("PLAYLISTS")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(.green)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .background(Color.black.opacity(0.9))

            if viewModel.isLoading && viewModel.playlists.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(viewModel.playlists) { playlist in
                            PlaylistRow(
                                playlist: playlist,
                                isSelected: viewModel.selectedPlaylist?.id == playlist.id
                            ) {
                                viewModel.loadTracks(for: playlist)
                            }
                        }
                    }
                }
            }
        }
    }

    private var trackList: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(viewModel.selectedPlaylist?.name ?? "SELECT A PLAYLIST")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.green)
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .scaleEffect(0.7)
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.9))

            if viewModel.playlistTracks.isEmpty {
                Spacer()
                Text(viewModel.selectedPlaylist == nil ? "Select a playlist" : "No tracks")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 1) {
                        ForEach(viewModel.playlistTracks) { track in
                            TrackRow(track: track) {
                                playerViewModel.play(track: track)
                            }
                        }
                    }
                }
            }
        }
    }
}

/// Row view for a playlist
struct PlaylistRow: View {
    let playlist: Playlist
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 2) {
                Text(playlist.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? .green : .white)
                    .lineLimit(1)

                Text("\(playlist.trackCount) tracks")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(isSelected ? Color.green.opacity(0.2) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Row view for a track
struct TrackRow: View {
    let track: Track
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                // Track number/play indicator
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.green.opacity(0.7))

                VStack(alignment: .leading, spacing: 2) {
                    Text(track.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(track.artistNamesString)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

                Text(track.formattedDuration)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.5))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
