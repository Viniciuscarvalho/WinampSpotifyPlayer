//
//  KeychainService.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Security

/// Low-level wrapper around macOS Security framework for Keychain operations
/// Uses actor isolation to ensure thread-safe access to Keychain
actor KeychainService {
    /// Service identifier for Keychain items
    private let service: String

    /// Initializes the Keychain service with a specific service identifier
    /// - Parameter service: The service name to use for Keychain items
    init(service: String = "com.winamp-spotify-player") {
        self.service = service
    }

    // MARK: - Save Operations

    /// Saves a string value to the Keychain
    /// - Parameters:
    ///   - value: The string value to save
    ///   - key: The key to associate with the value
    /// - Throws: KeychainError if the operation fails
    func save(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        // Try to add the item
        let addStatus = SecItemAdd(query as CFDictionary, nil)

        switch addStatus {
        case errSecSuccess:
            return
        case errSecDuplicateItem:
            // Item already exists, update it instead
            try update(value, for: key)
        case errSecAuthFailed:
            throw KeychainError.accessDenied
        default:
            throw KeychainError.unexpectedError(addStatus)
        }
    }

    /// Updates an existing Keychain item
    /// - Parameters:
    ///   - value: The new string value
    ///   - key: The key of the item to update
    /// - Throws: KeychainError if the operation fails
    private func update(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        switch updateStatus {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            throw KeychainError.itemNotFound
        case errSecAuthFailed:
            throw KeychainError.accessDenied
        default:
            throw KeychainError.unexpectedError(updateStatus)
        }
    }

    // MARK: - Retrieve Operations

    /// Retrieves a string value from the Keychain
    /// - Parameter key: The key associated with the value
    /// - Returns: The string value if found, nil otherwise
    /// - Throws: KeychainError if the operation fails (excluding itemNotFound)
    func retrieve(for key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data,
                  let value = String(data: data, encoding: .utf8) else {
                throw KeychainError.invalidData
            }
            return value
        case errSecItemNotFound:
            return nil
        case errSecAuthFailed:
            throw KeychainError.accessDenied
        default:
            throw KeychainError.unexpectedError(status)
        }
    }

    // MARK: - Delete Operations

    /// Deletes a Keychain item
    /// - Parameter key: The key of the item to delete
    /// - Throws: KeychainError if the operation fails
    func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        switch status {
        case errSecSuccess, errSecItemNotFound:
            // Success or item didn't exist - both are acceptable outcomes
            return
        case errSecAuthFailed:
            throw KeychainError.accessDenied
        default:
            throw KeychainError.unexpectedError(status)
        }
    }

    /// Deletes all Keychain items for this service
    /// - Throws: KeychainError if the operation fails
    func deleteAll() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)

        switch status {
        case errSecSuccess, errSecItemNotFound:
            return
        case errSecAuthFailed:
            throw KeychainError.accessDenied
        default:
            throw KeychainError.unexpectedError(status)
        }
    }
}
