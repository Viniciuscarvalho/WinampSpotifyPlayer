//
//  ArtistDTO.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Data Transfer Object for Spotify artist API responses
struct ArtistDTO: Decodable, Sendable {
    let id: String
    let name: String
    let images: [ImageDTO]?
    let genres: [String]?
}

extension ArtistDTO {
    /// Converts DTO to domain model
    func toDomainModel() -> Artist {
        Artist(
            id: id,
            name: name,
            imageURL: images?.first.flatMap { URL(string: $0.url) },
            genres: genres ?? []
        )
    }
}
