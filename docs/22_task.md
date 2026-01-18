# Task 22.0: Performance Optimization

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Profile the application with Instruments, identify performance bottlenecks, fix memory leaks, optimize UI rendering, and ensure all performance targets are met (UI <100ms, playback <2s, memory <200MB).

## Requirements

- All features implemented (Tasks 1-21)
- Xcode Instruments knowledge
- Understanding of Swift performance optimization
- Memory management best practices

## Subtasks

- [ ] 22.1 Profile app with Instruments (Time Profiler)
- [ ] 22.2 Profile memory usage with Instruments (Leaks, Allocations)
- [ ] 22.3 Identify and fix memory leaks in Combine subscriptions
- [ ] 22.4 Optimize image loading and caching
- [ ] 22.5 Optimize track list rendering for 1000+ tracks
- [ ] 22.6 Ensure UI responsiveness <100ms for all actions
- [ ] 22.7 Ensure playback start latency <2 seconds
- [ ] 22.8 Verify memory usage stays <200MB
- [ ] 22.9 Optimize API response parsing
- [ ] 22.10 Add lazy loading for large libraries
- [ ] 22.11 Profile and optimize startup time
- [ ] 22.12 Verify 60fps UI rendering
- [ ] 22.13 Test on lower-end Macs (if possible)
- [ ] 22.14 Document optimization decisions

## Implementation Details

### Memory Leak Prevention:
```swift
// Use [weak self] in all Combine subscriptions
playbackUseCase.playbackStatePublisher
    .sink { [weak self] state in
        self?.updateUI(with: state)
    }
    .store(in: &cancellables)

// Ensure cancellables are cleared on deinit
deinit {
    cancellables.removeAll()
}
```

### Image Caching:
```swift
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, NSImage>()

    func loadImage(from url: URL) async -> NSImage? {
        let key = url.absoluteString as NSString

        // Check cache first
        if let cached = cache.object(forKey: key) {
            return cached
        }

        // Download and cache
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let image = NSImage(data: data) else {
            return nil
        }

        cache.setObject(image, forKey: key)
        return image
    }
}
```

### Lazy Loading for Track Lists:
```swift
ScrollView {
    LazyVStack {
        ForEach(tracks) { track in
            TrackRow(track: track)
                .onAppear {
                    if track == tracks.last {
                        loadMoreTracks()
                    }
                }
        }
    }
}
```

### UI Performance:
```swift
// Debounce search to avoid excessive filtering
@Published var searchText = ""

$searchText
    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
    .sink { [weak self] text in
        self?.filterTracks(text)
    }
    .store(in: &cancellables)
```

### Profiling Checklist:
1. **Time Profiler**: Find CPU-intensive operations
2. **Allocations**: Track memory allocations and deallocations
3. **Leaks**: Detect retain cycles and memory leaks
4. **Energy**: Ensure app doesn't drain battery
5. **Network**: Check for excessive API calls

### Performance Targets (from PRD/TechSpec):
- **UI Responsiveness**: All interactions respond within 100ms
- **Playback Latency**: Track starts playing within 2 seconds
- **Memory Usage**: Stay under 200MB during normal use
- **Frame Rate**: Maintain 60fps during scrolling/animations
- **Startup Time**: App launches within 1 second (cold start)

## Success Criteria

- No memory leaks detected by Instruments
- Memory usage stays below 200MB during normal use
- All UI actions respond within 100ms
- Playback starts within 2 seconds of user action
- Track list scrolls smoothly with 1000+ tracks
- 60fps maintained during all animations
- No excessive API calls (verified with Network profiler)
- Image loading doesn't block main thread
- Startup time under 1 second (cold start)
- App performs well on older Macs (2018+)
- All performance targets documented and verified

## Dependencies

- All features implemented (Tasks 1-21)

## Relevant Files

- All source files (optimization applied throughout)
- `Core/Caching/ImageCache.swift`
- `Docs/PerformanceOptimizations.md`

## Task Context

| Property | Value |
|----------|-------|
| Domain | cross_cutting |
| Type | optimization |
| Scope | performance |
| Complexity | medium |
| Dependencies | all_features, xcode_instruments |
