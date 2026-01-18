# Task 10.0: Queue Management Use Case

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement QueueManagementUseCase to handle playback queue operations including adding tracks, removing tracks, reordering via drag-and-drop indices, and fetching the current queue.

## Requirements

- Task 7.0 completed (SpotifyPlaybackRepository implemented)
- Understanding of queue data structures
- Knowledge of drag-and-drop index calculations

## Subtasks

- [ ] 10.1 Create QueueManagementUseCase class
- [ ] 10.2 Implement addToQueue(trackURI:) method
- [ ] 10.3 Implement removeFromQueue(at index:) method
- [ ] 10.4 Implement reorderQueue(from:to:) method
- [ ] 10.5 Implement getCurrentQueue() method
- [ ] 10.6 Handle edge cases (empty queue, invalid indices)
- [ ] 10.7 Validate indices before queue operations
- [ ] 10.8 Write unit tests for adding tracks to queue
- [ ] 10.9 Write unit tests for removing tracks
- [ ] 10.10 Write unit tests for reordering
- [ ] 10.11 Test edge cases (invalid indices, empty queue)

## Implementation Details

### Index Validation:
```swift
func removeFromQueue(at index: Int) async throws {
    let queue = try await getCurrentQueue()
    guard index >= 0 && index < queue.count else {
        throw QueueError.invalidIndex
    }
    try await playbackRepository.removeFromQueue(at: index)
}
```

### Reorder Logic:
Handle drag-and-drop indices correctly:
```swift
func reorderQueue(from: Int, to: Int) async throws {
    let queue = try await getCurrentQueue()
    guard from >= 0 && from < queue.count,
          to >= 0 && to < queue.count else {
        throw QueueError.invalidIndex
    }
    try await playbackRepository.reorderQueue(from: from, to: to)
}
```

### Queue Error Types:
```swift
enum QueueError: Error {
    case invalidIndex
    case emptyQueue
    case operationFailed
}
```

## Success Criteria

- Can add track to queue successfully
- Can remove track from queue by index
- Can reorder tracks in queue
- Can fetch current queue
- Invalid indices throw appropriate errors
- Empty queue operations handled gracefully
- Reorder logic works for all valid index combinations
- All unit tests pass
- Tests cover edge cases (first item, last item, same index)
- No crashes on invalid operations

## Dependencies

- Task 7.0 (SpotifyPlaybackRepository)

## Relevant Files

- `Domain/UseCases/QueueManagementUseCase.swift`
- `Core/Errors/QueueError.swift`
- `WinampSpotifyPlayerTests/Domain/UseCases/QueueManagementUseCaseTests.swift`
- `WinampSpotifyPlayerTests/Mocks/MockSpotifyPlaybackRepository.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | domain_layer |
| Type | implementation |
| Scope | queue_management |
| Complexity | low |
| Dependencies | playback_repository |
