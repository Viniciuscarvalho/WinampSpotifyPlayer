# Task 20.0: Error Handling & User Feedback

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement comprehensive error handling throughout the app with user-friendly error messages, retry mechanisms, loading indicators, and skeleton screens for better UX.

## Requirements

- All core feature tasks completed (Tasks 1-19)
- Understanding of error handling patterns
- UX design knowledge for loading states

## Subtasks

- [ ] 20.1 Create comprehensive error types for each domain
- [ ] 20.2 Map technical errors to user-friendly messages
- [ ] 20.3 Implement retry mechanism for network failures
- [ ] 20.4 Add exponential backoff for API rate limiting
- [ ] 20.5 Create reusable ErrorView component
- [ ] 20.6 Add loading indicators to all async operations
- [ ] 20.7 Create skeleton screens for library loading
- [ ] 20.8 Handle offline state gracefully
- [ ] 20.9 Show connectivity status in UI
- [ ] 20.10 Implement toast notifications for minor errors
- [ ] 20.11 Add error logging (OSLog for development)
- [ ] 20.12 Test all error scenarios
- [ ] 20.13 Test retry mechanisms
- [ ] 20.14 Test offline mode handling

## Implementation Details

### Error Type Hierarchy:
```swift
enum AppError: LocalizedError {
    case network(NetworkError)
    case authentication(AuthError)
    case playback(PlaybackError)
    case library(LibraryError)

    var errorDescription: String? {
        switch self {
        case .network(.noConnection):
            return "No internet connection. Please check your network settings."
        case .authentication(.invalidCredentials):
            return "Failed to authenticate with Spotify. Please try logging in again."
        case .playback(.sdkNotReady):
            return "Playback not ready. Initializing player..."
        case .library(.emptyLibrary):
            return "No playlists found. Create some on Spotify first!"
        }
    }
}
```

### Retry Mechanism:
```swift
func executeWithRetry<T>(
    maxAttempts: Int = 3,
    operation: () async throws -> T
) async throws -> T {
    var lastError: Error?

    for attempt in 1...maxAttempts {
        do {
            return try await operation()
        } catch {
            lastError = error
            if attempt < maxAttempts {
                let delay = pow(2.0, Double(attempt)) // Exponential backoff
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }

    throw lastError!
}
```

### ErrorView Component:
```swift
struct ErrorView: View {
    let error: AppError
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)

            Text(error.localizedDescription)
                .multilineTextAlignment(.center)

            Button("Retry") {
                retryAction()
            }
            .buttonStyle(WinampButtonStyle())
        }
        .padding()
    }
}
```

### Skeleton Screen:
```swift
struct SkeletonView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<10) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 40)
                    .overlay(
                        LinearGradient(...)
                            .offset(x: isAnimating ? 300 : -300)
                    )
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}
```

### Offline Detection:
```swift
import Network

class NetworkMonitor: ObservableObject {
    @Published var isConnected = true
    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
}
```

## Success Criteria

- All errors display user-friendly messages (no technical jargon)
- Retry mechanism works for network failures
- Exponential backoff prevents API spam
- Loading indicators shown for all async operations
- Skeleton screens displayed during library loading
- Offline state detected and displayed to user
- Toast notifications show for minor errors
- All error scenarios tested (network, auth, playback)
- No uncaught exceptions or crashes
- Error logging captures useful debug info
- Retry works for at least 3 common error scenarios

## Dependencies

- All core feature tasks (1-19)

## Relevant Files

- `Core/Errors/AppError.swift`
- `Core/Networking/RetryPolicy.swift`
- `Core/Monitoring/NetworkMonitor.swift`
- `Presentation/Components/ErrorView.swift`
- `Presentation/Components/SkeletonView.swift`
- `Presentation/Components/LoadingIndicator.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | cross_cutting |
| Type | implementation |
| Scope | error_handling_ux |
| Complexity | medium |
| Dependencies | all_features |
