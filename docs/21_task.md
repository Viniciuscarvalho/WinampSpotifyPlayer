# Task 21.0: Accessibility Implementation

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement comprehensive accessibility support including VoiceOver labels, keyboard navigation, reduced motion support, and high contrast mode. Ensure app is usable by users with disabilities.

## Requirements

- All UI tasks completed (Tasks 13-17)
- Understanding of macOS accessibility APIs
- VoiceOver testing experience

## Subtasks

- [ ] 21.1 Add accessibility labels to all buttons
- [ ] 21.2 Add accessibility hints where helpful
- [ ] 21.3 Add accessibility values for dynamic content (time, volume)
- [ ] 21.4 Implement full keyboard navigation
- [ ] 21.5 Add keyboard shortcuts (Space, Cmd+arrows, etc.)
- [ ] 21.6 Test VoiceOver navigation through entire app
- [ ] 21.7 Ensure all interactive elements focusable
- [ ] 21.8 Implement Reduced Motion support
- [ ] 21.9 Verify color contrast ratios (4.5:1 minimum)
- [ ] 21.10 Add focus indicators for keyboard navigation
- [ ] 21.11 Support Dynamic Type (where applicable)
- [ ] 21.12 Test with Accessibility Inspector
- [ ] 21.13 Create accessibility documentation
- [ ] 21.14 Test all accessibility features end-to-end

## Implementation Details

### VoiceOver Labels:
```swift
// Buttons
WinampButton(iconName: "play", action: play)
    .accessibilityLabel("Play")
    .accessibilityHint("Starts playback of the current track")

// Progress bar
ProgressBar(progress: $progress, onSeek: seek)
    .accessibilityLabel("Playback progress")
    .accessibilityValue("\(currentTime) of \(totalTime)")
    .accessibilityAdjustableAction { direction in
        switch direction {
        case .increment: seek(to: currentPosition + 5)
        case .decrement: seek(to: currentPosition - 5)
        }
    }

// Volume slider
VolumeSlider(volume: $volume)
    .accessibilityLabel("Volume")
    .accessibilityValue("\(volume) percent")
```

### Keyboard Shortcuts:
```swift
.onAppear {
    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
        switch event.keyCode {
        case 49: // Space
            togglePlayPause()
            return nil
        case 126: // Up arrow
            if event.modifierFlags.contains(.command) {
                increaseVolume()
                return nil
            }
        case 125: // Down arrow
            if event.modifierFlags.contains(.command) {
                decreaseVolume()
                return nil
            }
        case 123: // Left arrow
            if event.modifierFlags.contains(.command) {
                previousTrack()
                return nil
            }
        case 124: // Right arrow
            if event.modifierFlags.contains(.command) {
                nextTrack()
                return nil
            }
        default:
            break
        }
        return event
    }
}
```

### Reduced Motion:
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

var animation: Animation? {
    reduceMotion ? nil : .easeInOut(duration: 0.3)
}

// Use in animations
withAnimation(animation) {
    // Animate only if Reduced Motion is off
}
```

### Color Contrast:
Verify all text meets WCAG AA standards:
- Normal text: 4.5:1 contrast ratio
- Large text (18pt+): 3:1 contrast ratio
- Use Accessibility Inspector to verify

### Focus Indicators:
```swift
.focusable(true)
.onFocusChange { isFocused in
    self.isFocused = isFocused
}
.overlay(
    RoundedRectangle(cornerRadius: 4)
        .stroke(Color.blue, lineWidth: isFocused ? 2 : 0)
)
```

Reference: https://developer.apple.com/accessibility/

## Success Criteria

- All buttons have descriptive accessibility labels
- All dynamic content (time, volume) has accessibility values
- VoiceOver can navigate entire app without mouse
- All interactive elements reachable via Tab key
- Keyboard shortcuts work for common actions
- Reduced Motion preference respected
- All text meets 4.5:1 contrast ratio (verified with tools)
- Focus indicators visible during keyboard navigation
- Accessibility Inspector shows no critical issues
- Documentation created for accessibility features
- Tested with VoiceOver by actual screen reader user (if possible)

## Dependencies

- All UI tasks (13-17)

## Relevant Files

- All View files (add accessibility modifiers)
- `Docs/AccessibilityGuide.md`
- `Core/Accessibility/KeyboardShortcuts.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | cross_cutting |
| Type | implementation |
| Scope | accessibility |
| Complexity | medium |
| Dependencies | all_ui_features |
