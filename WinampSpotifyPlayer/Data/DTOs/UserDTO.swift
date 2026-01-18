//
//  UserDTO.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Data Transfer Object for Spotify user API responses
struct UserDTO: Decodable, Sendable {
    let id: String
    let display_name: String
    let email: String?
    let images: [ImageDTO]?
}

/// DTO for image objects in Spotify API responses
struct ImageDTO: Decodable, Sendable {
    let url: String
    let height: Int?
    let width: Int?
}

extension UserDTO {
    /// Converts DTO to domain model
    func toDomainModel() -> User {
        User(
            id: id,
            displayName: display_name,
            email: email,
            imageURL: images?.first.flatMap { URL(string: $0.url) }
        )
    }
}
