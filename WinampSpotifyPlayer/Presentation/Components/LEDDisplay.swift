//
//  LEDDisplay.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

/// LED-style text display for track info and time
struct LEDDisplay: View {
    let text: String
    var color: Color = .green

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold, design: .monospaced))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(minWidth: 60)
            .background(Color.black)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

/// Scrolling text display for long track names
struct ScrollingLEDDisplay: View {
    let text: String
    var color: Color = .green

    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(color)
                .lineLimit(1)
                .fixedSize()
                .background(
                    GeometryReader { textGeometry in
                        Color.clear.onAppear {
                            textWidth = textGeometry.size.width
                        }
                    }
                )
                .offset(x: offset)
                .onAppear {
                    if textWidth > geometry.size.width {
                        animateScroll(containerWidth: geometry.size.width)
                    }
                }
        }
        .frame(height: 20)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .clipped()
    }

    private func animateScroll(containerWidth: CGFloat) {
        let scrollDistance = textWidth + 50 // Add padding before repeat
        withAnimation(.linear(duration: Double(scrollDistance / 30)).repeatForever(autoreverses: false)) {
            offset = -scrollDistance
        }
    }
}
