//
//  PlaylistDTO.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Data Transfer Object for Spotify playlist API responses
struct PlaylistDTO: Decodable, Sendable {
    let id: String
    let name: String
    let description: String?
    let tracks: TracksContainerDTO
    let images: [ImageDTO]?
    let owner: OwnerDTO
}

/// DTO for playlist tracks container
struct TracksContainerDTO: Decodable, Sendable {
    let total: Int
}

/// DTO for playlist owner information
struct OwnerDTO: Decodable, Sendable {
    let id: String
    let display_name: String?
}

extension PlaylistDTO {
    /// Converts DTO to domain model
    func toDomainModel() -> Playlist {
        Playlist(
            id: id,
            name: name,
            description: description,
            trackCount: tracks.total,
            imageURL: images?.first.flatMap { URL(string: $0.url) },
            owner: owner.display_name ?? owner.id
        )
    }
}
