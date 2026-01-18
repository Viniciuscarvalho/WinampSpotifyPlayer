//
//  KeychainError.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Errors that can occur during Keychain operations
enum KeychainError: Error, LocalizedError {
    /// The requested item was not found in the Keychain
    case itemNotFound

    /// An item with the same key already exists
    case duplicateItem

    /// Access to the Keychain was denied
    case accessDenied

    /// An unexpected error occurred with the given OSStatus
    case unexpectedError(OSStatus)

    /// Failed to convert data to string
    case invalidData

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "The requested item was not found in the Keychain"
        case .duplicateItem:
            return "An item with this key already exists in the Keychain"
        case .accessDenied:
            return "Access to the Keychain was denied"
        case .unexpectedError(let status):
            return "An unexpected Keychain error occurred (OSStatus: \(status))"
        case .invalidData:
            return "Failed to convert Keychain data to string"
        }
    }
}
