//
//  TrackDTO.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Data Transfer Object for Spotify track API responses
struct TrackDTO: Decodable {
    let id: String
    let uri: String
    let name: String
    let artists: [ArtistDTO]
    let album: AlbumDTO
    let duration_ms: Int
}

extension TrackDTO {
    /// Converts DTO to domain model
    func toDomainModel() -> Track {
        Track(
            id: id,
            uri: uri,
            name: name,
            artistNames: artists.map { $0.name },
            albumName: album.name,
            durationMs: duration_ms,
            albumArtURL: album.images?.first.flatMap { URL(string: $0.url) }
        )
    }
}
