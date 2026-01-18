# Task 6.0: Authentication UI

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Build the authentication user interface with SwiftUI, featuring a Winamp-styled login screen. Create AuthViewModel to manage authentication state and wire up the OAuth flow to the UI.

## Requirements

- Task 5.0 completed (SpotifyAuthUseCase implemented)
- SwiftUI knowledge
- Basic understanding of Combine framework

## Subtasks

- [ ] 6.1 Create AuthenticationView with SwiftUI
- [ ] 6.2 Design Winamp-styled welcome screen
- [ ] 6.3 Add "Connect to Spotify" button with Winamp aesthetic
- [ ] 6.4 Create AuthViewModel with @Published state properties
- [ ] 6.5 Implement authentication state enum (idle, authenticating, authenticated, error)
- [ ] 6.6 Wire up button tap to AuthViewModel.authenticate()
- [ ] 6.7 Show loading indicator during OAuth flow
- [ ] 6.8 Handle authentication errors with user-friendly messages
- [ ] 6.9 Navigate to main player on successful authentication
- [ ] 6.10 Add retry mechanism for failed authentication
- [ ] 6.11 Display user profile info after successful login
- [ ] 6.12 Write unit tests for AuthViewModel state transitions

## Implementation Details

### AuthViewModel Structure:
```swift
@MainActor
class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .idle
    @Published var errorMessage: String?
    @Published var currentUser: User?

    private let authUseCase: SpotifyAuthUseCaseProtocol

    func authenticate() async { }
    func logout() async { }
}
```

### Auth State Machine:
```swift
enum AuthState {
    case idle
    case authenticating
    case authenticated
    case error(String)
}
```

### UI Flow:
1. Show Winamp-styled welcome screen
2. User taps "Connect to Spotify"
3. Show loading state
4. Browser opens for OAuth
5. On success → Navigate to main player
6. On error → Show error message with retry button

## Success Criteria

- AuthenticationView renders correctly with Winamp aesthetic
- Button triggers OAuth flow via AuthViewModel
- Loading state displayed during authentication
- Success navigates to main player screen
- Errors display user-friendly messages
- Retry button works after authentication failure
- User profile info displayed after successful login
- ViewModel tests cover all state transitions
- View responds to ViewModel state changes reactively
- No UI freezing during OAuth (runs on background thread)

## Dependencies

- Task 5.0 (SpotifyAuthUseCase)

## Relevant Files

- `Presentation/Views/AuthenticationView.swift`
- `Presentation/ViewModels/AuthViewModel.swift`
- `WinampSpotifyPlayerTests/Presentation/ViewModels/AuthViewModelTests.swift`
- `Resources/Assets.xcassets/WinampUI/` (for styled assets)

## Task Context

| Property | Value |
|----------|-------|
| Domain | presentation_layer |
| Type | implementation |
| Scope | authentication_ui |
| Complexity | medium |
| Dependencies | swiftui, combine, auth_use_case |
