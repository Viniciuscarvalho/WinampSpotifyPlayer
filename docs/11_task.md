# Task 11.0: Winamp Asset Creation

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Extract and design UI assets from Winamp Classified v5.5 skin for Retina displays. Create @2x and @3x versions of all UI elements including buttons, backgrounds, LED displays, and other visual components.

## Requirements

- Access to Winamp Classified v5.5 skin reference (https://skins.webamp.org/skin/cd251187a5e6ff54ce938d26f1f2de02/Winamp3_Classified_v5.5.wsz/)
- Image editing software (Sketch, Figma, or Photoshop)
- Understanding of Retina display asset requirements

## Subtasks

- [ ] 11.1 Extract visual assets from Winamp Classified v5.5 skin
- [ ] 11.2 Create button assets (play, pause, stop, next, previous)
- [ ] 11.3 Create slider assets (volume slider, seek bar)
- [ ] 11.4 Create LED display assets for time and track info
- [ ] 11.5 Create progress bar assets
- [ ] 11.6 Create window background textures
- [ ] 11.7 Create icon assets for shuffle and repeat buttons
- [ ] 11.8 Export all assets at @2x resolution (588x200px for main window)
- [ ] 11.9 Export all assets at @3x resolution (882x300px for main window)
- [ ] 11.10 Add assets to Assets.xcassets
- [ ] 11.11 Create Color+Hex extension with Winamp color palette
- [ ] 11.12 Document asset naming conventions
- [ ] 11.13 Test assets on Retina and non-Retina displays

## Implementation Details

### Asset Categories:
1. **Buttons**: play, pause, stop, next, prev, shuffle, repeat, eject, menu
2. **Sliders**: volume knob, seek bar thumb
3. **Backgrounds**: main window, playlist window, title bar
4. **Displays**: LED time display, track title scroller
5. **Indicators**: volume bars, spectrum analyzer placeholders
6. **Icons**: app icon, menu bar icon

### Winamp Main Window Dimensions:
- Original: 275x116px
- @2x: 550x232px
- @3x: 825x348px
- Use fixed size to maintain authentic Winamp aesthetic

### Color Palette (from Classified v5.5):
```swift
extension Color {
    static let winampBackground = Color(hex: "#0E0E0E")
    static let winampLEDGreen = Color(hex: "#00FF00")
    static let winampButtonNormal = Color(hex: "#2A2A2A")
    static let winampButtonPressed = Color(hex: "#1A1A1A")
    static let winampAccent = Color(hex: "#4A9EFF")
    // ... add all colors from skin
}
```

### Asset Organization:
```
Assets.xcassets/
├── WinampUI/
│   ├── Buttons/
│   ├── Sliders/
│   ├── Backgrounds/
│   ├── Displays/
│   └── Icons/
└── AppIcon.appiconset/
```

## Success Criteria

- All UI elements extracted from original skin
- Assets rendered at @2x and @3x for Retina displays
- Assets look crisp on all display resolutions
- Color palette matches Winamp Classified v5.5
- Assets added to Xcode Assets.xcassets
- Color+Hex extension created with palette
- All assets named consistently (camelCase)
- Main window maintains 275x116 aspect ratio when scaled
- Assets tested on different display resolutions
- No pixelation or blurriness on Retina displays

## Dependencies

None - This is design/asset work that can be done independently

## Relevant Files

- `Resources/Assets.xcassets/WinampUI/`
- `Core/Extensions/Color+Hex.swift`
- `Docs/AssetNamingConventions.md`

## Task Context

| Property | Value |
|----------|-------|
| Domain | ui_assets |
| Type | design |
| Scope | visual_assets |
| Complexity | medium |
| Dependencies | none |
