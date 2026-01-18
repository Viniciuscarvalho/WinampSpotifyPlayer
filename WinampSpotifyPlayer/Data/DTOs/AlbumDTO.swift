//
//  AlbumDTO.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Data Transfer Object for Spotify album API responses
struct AlbumDTO: Decodable, Sendable {
    let id: String
    let name: String
    let artists: [ArtistDTO]
    let release_date: String
    let total_tracks: Int
    let images: [ImageDTO]?
}

extension AlbumDTO {
    /// Converts DTO to domain model
    func toDomainModel() -> Album {
        Album(
            id: id,
            name: name,
            artistNames: artists.map { $0.name },
            releaseDate: release_date,
            trackCount: total_tracks,
            imageURL: images?.first.flatMap { URL(string: $0.url) }
        )
    }
}
