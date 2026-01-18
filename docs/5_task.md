# Task 5.0: Spotify OAuth Implementation

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement Spotify OAuth 2.0 authentication flow using ASWebAuthenticationSession. Handle authorization code exchange, token refresh, and secure token storage via KeychainRepository.

## Requirements

- Task 3.0 completed (KeychainRepository implemented)
- Task 4.0 completed (HTTP client available)
- Spotify Developer Account with registered OAuth app
- Understanding of OAuth 2.0 Authorization Code flow

## Subtasks

- [ ] 5.1 Register app on Spotify Developer Dashboard
- [ ] 5.2 Configure OAuth redirect URI (winampspotify://callback)
- [ ] 5.3 Store client ID and client secret securely (not in code)
- [ ] 5.4 Implement authenticate() using ASWebAuthenticationSession
- [ ] 5.5 Build authorization URL with required scopes
- [ ] 5.6 Handle callback and extract authorization code
- [ ] 5.7 Exchange authorization code for access/refresh tokens
- [ ] 5.8 Store tokens in Keychain via KeychainRepository
- [ ] 5.9 Implement refreshAccessToken() logic
- [ ] 5.10 Implement logout() to clear tokens
- [ ] 5.11 Implement isAuthenticated computed property
- [ ] 5.12 Fetch user profile after successful auth
- [ ] 5.13 Write unit tests for auth flow (mock ASWebAuthenticationSession)
- [ ] 5.14 Write unit tests for token refresh
- [ ] 5.15 Test logout clears all tokens

## Implementation Details

### Required OAuth Scopes:
```swift
let scopes = [
    "user-read-email",
    "user-read-private",
    "user-library-read",
    "user-read-playback-state",
    "user-modify-playback-state",
    "streaming",
    "playlist-read-private",
    "playlist-read-collaborative"
].joined(separator: "%20")
```

### Authorization URL Format:
```
https://accounts.spotify.com/authorize?
  client_id=YOUR_CLIENT_ID&
  response_type=code&
  redirect_uri=winampspotify://callback&
  scope=SCOPES&
  show_dialog=true
```

### Token Exchange:
POST to `https://accounts.spotify.com/api/token` with:
- `grant_type=authorization_code`
- `code=AUTHORIZATION_CODE`
- `redirect_uri=winampspotify://callback`
- `client_id=YOUR_CLIENT_ID`
- `client_secret=YOUR_CLIENT_SECRET`

### Token Refresh:
POST to `https://accounts.spotify.com/api/token` with:
- `grant_type=refresh_token`
- `refresh_token=REFRESH_TOKEN`
- `client_id=YOUR_CLIENT_ID`

Reference: https://developer.spotify.com/documentation/web-api/tutorials/code-flow

## Success Criteria

- OAuth flow opens browser successfully
- User can authorize app in Spotify
- App receives callback with authorization code
- Authorization code exchanges for tokens successfully
- Tokens stored securely in Keychain
- Token refresh works when access token expires
- User profile fetched after authentication
- Logout clears all tokens from Keychain
- All unit tests pass
- No client secret in source code (use environment variable or config file)

## Dependencies

- Task 3.0 (Keychain integration)
- Task 4.0 (HTTP client)
- Spotify Developer Account (external)

## Relevant Files

- `Domain/UseCases/SpotifyAuthUseCase.swift`
- `Core/Networking/OAuthClient.swift`
- `WinampSpotifyPlayerTests/Domain/UseCases/SpotifyAuthUseCaseTests.swift`
- `WinampSpotifyPlayerTests/Mocks/MockKeychainRepository.swift`
- Config file for client ID/secret (not in Git)

## Task Context

| Property | Value |
|----------|-------|
| Domain | domain_layer |
| Type | implementation |
| Scope | authentication |
| Complexity | medium |
| Dependencies | spotify_oauth, keychain, http_client |
