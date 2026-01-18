//
//  ProgressBar.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

/// Winamp-styled progress bar for track position
struct ProgressBar: View {
    @Binding var progress: Double // 0.0 to 1.0
    let onSeek: (Double) -> Void

    @State private var isDragging = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.black)
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )

                // Progress fill
                Rectangle()
                    .fill(Color.green)
                    .frame(width: geometry.size.width * progress)
            }
            .frame(height: 8)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        let newProgress = max(0, min(1, value.location.x / geometry.size.width))
                        progress = newProgress
                    }
                    .onEnded { value in
                        isDragging = false
                        let finalProgress = max(0, min(1, value.location.x / geometry.size.width))
                        onSeek(finalProgress)
                    }
            )
        }
        .frame(height: 8)
    }
}
