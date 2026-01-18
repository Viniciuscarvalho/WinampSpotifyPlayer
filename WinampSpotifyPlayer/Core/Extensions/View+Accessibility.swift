//
//  View+Accessibility.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

extension View {
    /// Makes a view accessible with label and hint
    func accessibleElement(label: String, hint: String? = nil, traits: AccessibilityTraits = []) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }

    /// Makes a button accessible
    func accessibleButton(label: String, hint: String? = nil) -> some View {
        self.accessibleElement(label: label, hint: hint, traits: .isButton)
    }
}
