# Task 15.0: Queue View & Drag-and-Drop

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Add queue display to the playlist window showing upcoming tracks. Implement drag-and-drop reordering with visual feedback and wire up to QueueManagementUseCase.

## Requirements

- Task 10.0 completed (QueueManagementUseCase)
- Task 14.0 completed (Playlist window exists)
- Understanding of SwiftUI drag gestures

## Subtasks

- [ ] 15.1 Add "Queue" tab to playlist window
- [ ] 15.2 Create QueueViewModel with @Published state
- [ ] 15.3 Fetch and display current queue
- [ ] 15.4 Implement drag-and-drop reordering
- [ ] 15.5 Add visual feedback during drag (ghost item)
- [ ] 15.6 Implement drop target highlighting
- [ ] 15.7 Calculate correct indices for reorder operation
- [ ] 15.8 Add "Remove from Queue" context menu option
- [ ] 15.9 Show current playing track highlighted
- [ ] 15.10 Handle empty queue state
- [ ] 15.11 Update queue in real-time during playback
- [ ] 15.12 Write unit tests for QueueViewModel
- [ ] 15.13 Test drag-and-drop index calculations

## Implementation Details

### QueueViewModel Structure:
```swift
@MainActor
class QueueViewModel: ObservableObject {
    @Published var queueTracks: [Track] = []
    @Published var currentTrackIndex: Int = 0
    @Published var isLoading = false

    private let queueUseCase: QueueManagementUseCaseProtocol

    func fetchQueue() async { }
    func reorder(from: Int, to: Int) async { }
    func remove(at index: Int) async { }
}
```

### Drag-and-Drop Implementation:
```swift
ForEach(viewModel.queueTracks) { track in
    TrackRow(track: track)
        .onDrag {
            draggedTrack = track
            return NSItemProvider(object: track.id as NSString)
        }
        .onDrop(of: [.text], delegate: QueueDropDelegate(
            item: track,
            items: $viewModel.queueTracks,
            draggedItem: $draggedTrack,
            onReorder: viewModel.reorder
        ))
}
```

### Drop Delegate:
```swift
struct QueueDropDelegate: DropDelegate {
    let item: Track
    @Binding var items: [Track]
    @Binding var draggedItem: Track?

    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = draggedItem,
              let fromIndex = items.firstIndex(of: draggedItem),
              let toIndex = items.firstIndex(of: item) else {
            return false
        }

        onReorder(fromIndex, toIndex)
        return true
    }
}
```

### Visual Feedback:
- Ghost item follows cursor during drag
- Drop target shows highlight bar
- Smooth animation when item drops
- Current playing track has distinct highlight

## Success Criteria

- Queue displays all upcoming tracks
- Drag-and-drop reordering works smoothly
- Visual feedback clear during drag operation
- Correct indices calculated for all drag scenarios
- Can remove tracks from queue via context menu
- Current playing track highlighted
- Empty queue shows helpful message
- Queue updates in real-time during playback
- All ViewModel tests pass
- No index out of bounds errors
- Drag animation smooth (<16ms frame time)

## Dependencies

- Task 10.0 (QueueManagementUseCase)
- Task 14.0 (Playlist window)

## Relevant Files

- `Presentation/Views/QueueView.swift`
- `Presentation/ViewModels/QueueViewModel.swift`
- `Presentation/Components/QueueDropDelegate.swift`
- `WinampSpotifyPlayerTests/Presentation/ViewModels/QueueViewModelTests.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | presentation_layer |
| Type | implementation |
| Scope | queue_ui |
| Complexity | low |
| Dependencies | queue_use_case, swiftui_drag_drop |
