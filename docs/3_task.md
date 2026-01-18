# Task 3.0: Keychain Integration

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement secure token storage using macOS Keychain Services framework. Create KeychainRepository that handles saving, retrieving, and deleting OAuth tokens (access token and refresh token) with proper security attributes.

## Requirements

- Task 2.0 completed (KeychainRepositoryProtocol defined)
- Understanding of macOS Security framework
- Knowledge of Keychain access control attributes

## Subtasks

- [ ] 3.1 Create KeychainService wrapper around Security framework
- [ ] 3.2 Implement save(accessToken:) method
- [ ] 3.3 Implement save(refreshToken:) method
- [ ] 3.4 Implement getAccessToken() method
- [ ] 3.5 Implement getRefreshToken() method
- [ ] 3.6 Implement deleteTokens() method
- [ ] 3.7 Create KeychainError enum for error handling
- [ ] 3.8 Write unit tests for all Keychain operations
- [ ] 3.9 Test with actual Keychain (not just mocks)

## Implementation Details

### Security Configuration:
- **Service Name**: `com.yourcompany.winamp-spotify-player`
- **Account Name**: `spotify_access_token` and `spotify_refresh_token`
- **Security Class**: `kSecClassGenericPassword`
- **Access Control**: `kSecAttrAccessibleAfterFirstUnlock`

### Key Security Framework Functions:
- `SecItemAdd` - Add new Keychain item
- `SecItemCopyMatching` - Retrieve Keychain item
- `SecItemUpdate` - Update existing item
- `SecItemDelete` - Delete Keychain item

### Error Handling:
Create custom errors for:
- Item not found
- Duplicate item
- Access denied
- Unexpected error (with OSStatus code)

Reference: https://developer.apple.com/documentation/security/keychain_services

## Success Criteria

- Can save access token to Keychain successfully
- Can save refresh token to Keychain successfully
- Can retrieve tokens from Keychain
- Can delete all tokens from Keychain
- Handles duplicate save gracefully (updates existing item)
- Handles missing items gracefully (returns nil)
- All unit tests pass
- No tokens logged to console (security requirement)
- Tokens persist across app launches

## Dependencies

- Task 2.0 (KeychainRepositoryProtocol defined)

## Relevant Files

- `Core/Keychain/KeychainService.swift`
- `Core/Keychain/KeychainError.swift`
- `Data/Repositories/KeychainRepository.swift`
- `WinampSpotifyPlayerTests/Data/Repositories/KeychainRepositoryTests.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | data_layer |
| Type | implementation |
| Scope | security |
| Complexity | low |
| Dependencies | macOS_security_framework |
