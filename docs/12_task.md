# Task 12.0: Reusable Winamp UI Components

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Create reusable SwiftUI components that replicate Winamp UI elements including styled buttons, LED displays, progress bars, and volume sliders. Add accessibility support and keyboard navigation to all components.

## Requirements

- Task 11.0 completed (assets available)
- SwiftUI knowledge
- Understanding of accessibility requirements

## Subtasks

- [ ] 12.1 Create WinampButton component with pressed/normal states
- [ ] 12.2 Create LEDDisplay component for time/track info
- [ ] 12.3 Create ProgressBar component for track progress
- [ ] 12.4 Create VolumeSlider component
- [ ] 12.5 Add hover effects to buttons
- [ ] 12.6 Add accessibility labels to all components
- [ ] 12.7 Add keyboard navigation support
- [ ] 12.8 Create component previews for Xcode canvas
- [ ] 12.9 Add haptic feedback on button presses (if supported)
- [ ] 12.10 Test components on different display resolutions
- [ ] 12.11 Test VoiceOver navigation
- [ ] 12.12 Document component usage with examples

## Implementation Details

### WinampButton:
```swift
struct WinampButton: View {
    let iconName: String
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .frame(width: 23, height: 18)
        }
        .buttonStyle(WinampButtonStyle())
        .accessibilityLabel("Play button")
    }
}
```

### LEDDisplay:
```swift
struct LEDDisplay: View {
    let text: String
    let width: CGFloat = 100

    var body: some View {
        Text(text)
            .font(.custom("LED", size: 12))
            .foregroundColor(.winampLEDGreen)
            .frame(width: width)
            .background(Color.black)
    }
}
```

### ProgressBar:
```swift
struct ProgressBar: View {
    @Binding var progress: Double // 0.0 - 1.0
    let onSeek: (Double) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                // Fill based on progress
                // Draggable thumb
            }
        }
    }
}
```

### VolumeSlider:
Vertical slider matching Winamp aesthetic with 0-100 range.

### Accessibility:
- All buttons: `.accessibilityLabel()` and `.accessibilityHint()`
- Progress bar: `.accessibilityValue()` for current position
- Volume slider: `.accessibilityValue()` for volume level
- LED display: `.accessibilityLabel()` for track info

## Success Criteria

- All components render with authentic Winamp styling
- Buttons show visual feedback on press
- LED display shows text with green LED effect
- Progress bar updates smoothly during playback
- Volume slider adjusts volume from 0-100
- All components accessible via VoiceOver
- Keyboard navigation works for all interactive elements
- Components responsive within <16ms (60fps)
- Preview canvas works for all components
- Components reusable across different views
- No performance issues with multiple components

## Dependencies

- Task 11.0 (Winamp assets)

## Relevant Files

- `Presentation/Components/WinampButton.swift`
- `Presentation/Components/LEDDisplay.swift`
- `Presentation/Components/ProgressBar.swift`
- `Presentation/Components/VolumeSlider.swift`
- `Presentation/Components/WinampButtonStyle.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | presentation_layer |
| Type | implementation |
| Scope | ui_components |
| Complexity | medium |
| Dependencies | swiftui, assets |
