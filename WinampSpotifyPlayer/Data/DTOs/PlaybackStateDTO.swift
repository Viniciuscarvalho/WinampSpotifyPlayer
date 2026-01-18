//
//  PlaybackStateDTO.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Data Transfer Object for Spotify Web Playback SDK state
///
/// This DTO represents the player state object received from the
/// Spotify Web Playback SDK via the JavaScript bridge.
struct PlaybackStateDTO: Decodable, Sendable {
    let paused: Bool
    let position: Int
    let duration: Int
    let shuffle: Bool
    let repeat_mode: Int // 0 = off, 1 = context, 2 = track
    let track_window: TrackWindowDTO

    /// DTO for the current track window
    struct TrackWindowDTO: Decodable, Sendable {
        let current_track: TrackInfoDTO
    }

    /// Simplified track info from the playback SDK
    struct TrackInfoDTO: Decodable, Sendable {
        let id: String
        let uri: String
        let name: String
        let artists: [SimpleArtistDTO]
        let album: SimpleAlbumDTO
        let duration_ms: Int
    }

    /// Simplified artist info from playback SDK
    struct SimpleArtistDTO: Decodable, Sendable {
        let name: String
    }

    /// Simplified album info from playback SDK
    struct SimpleAlbumDTO: Decodable, Sendable {
        let name: String
        let images: [ImageDTO]
    }
}

extension PlaybackStateDTO {
    /// Converts DTO to domain model
    func toDomainModel() -> PlaybackState {
        let repeatMode: RepeatMode = {
            switch repeat_mode {
            case 0: return .off
            case 1: return .context
            case 2: return .track
            default: return .off
            }
        }()

        let currentTrack = Track(
            id: track_window.current_track.id,
            uri: track_window.current_track.uri,
            name: track_window.current_track.name,
            artistNames: track_window.current_track.artists.map { $0.name },
            albumName: track_window.current_track.album.name,
            durationMs: track_window.current_track.duration_ms,
            albumArtURL: track_window.current_track.album.images.first.flatMap { URL(string: $0.url) }
        )

        return PlaybackState(
            isPlaying: !paused,
            currentTrack: currentTrack,
            positionMs: position,
            durationMs: duration,
            volume: 50, // Will be updated separately
            shuffleState: shuffle,
            repeatMode: repeatMode
        )
    }
}
