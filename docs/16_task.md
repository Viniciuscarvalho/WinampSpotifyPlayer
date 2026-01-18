# Task 16.0: Media Keys Integration

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement global media key capture using CGEventTap to respond to keyboard play/pause, next, and previous keys. Handle conflicts with other apps and add user preference to enable/disable.

## Requirements

- Task 8.0 completed (PlaybackControlUseCase)
- Understanding of CGEventTap and macOS event system
- Accessibility permissions knowledge

## Subtasks

- [ ] 16.1 Create MediaKeyHandler class
- [ ] 16.2 Request accessibility permission if needed
- [ ] 16.3 Set up CGEventTap for media key events
- [ ] 16.4 Filter for NX_SYSDEFINED events (media keys)
- [ ] 16.5 Implement play/pause key handler
- [ ] 16.6 Implement next track key handler
- [ ] 16.7 Implement previous track key handler
- [ ] 16.8 Wire handlers to PlaybackControlUseCase
- [ ] 16.9 Add user preference to enable/disable media keys
- [ ] 16.10 Handle accessibility permission denied gracefully
- [ ] 16.11 Clean up event tap on app termination
- [ ] 16.12 Test with other apps running (Spotify, Apple Music)
- [ ] 16.13 Document known conflicts

## Implementation Details

### CGEventTap Setup:
```swift
class MediaKeyHandler {
    private var eventTap: CFMachPort?

    func startListening() {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: mediaKeyEventCallback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("Failed to create event tap")
            return
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        self.eventTap = eventTap
    }
}
```

### Media Key Codes:
- Play/Pause: NX_KEYTYPE_PLAY (16)
- Next: NX_KEYTYPE_NEXT (17)
- Previous: NX_KEYTYPE_PREVIOUS (18)
- Fast Forward: NX_KEYTYPE_FAST (19)
- Rewind: NX_KEYTYPE_REWIND (20)

### Accessibility Permission:
```swift
func checkAccessibilityPermission() -> Bool {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    return AXIsProcessTrustedWithOptions(options)
}
```

Reference: https://developer.apple.com/documentation/coregraphics/cgeventtap

## Success Criteria

- Media keys captured successfully
- Play/pause toggles playback
- Next/previous skip tracks correctly
- Accessibility permission requested on first run
- Permission denied handled gracefully with message
- User preference to disable media keys works
- Event tap cleaned up on app termination
- Works alongside other music apps (tested)
- No crashes or memory leaks
- Documented conflicts with other apps

## Dependencies

- Task 8.0 (PlaybackControlUseCase)

## Relevant Files

- `Services/MediaKeyHandler.swift`
- `Core/Permissions/AccessibilityPermissionManager.swift`
- `App/AppDelegate.swift` (for setup)
- `Docs/MediaKeyConflicts.md`

## Task Context

| Property | Value |
|----------|-------|
| Domain | macos_integration |
| Type | implementation |
| Scope | media_keys |
| Complexity | medium |
| Dependencies | coregraphics, accessibility_permissions |
