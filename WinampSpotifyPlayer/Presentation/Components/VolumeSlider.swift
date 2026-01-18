//
//  VolumeSlider.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

/// Vertical volume slider with Winamp styling
struct VolumeSlider: View {
    @Binding var volume: Double // 0.0 to 1.0
    let onChange: (Double) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background track
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 20)
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )

                // Volume fill
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 20, height: geometry.size.height * volume)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let newVolume = 1.0 - max(0, min(1, value.location.y / geometry.size.height))
                        volume = newVolume
                        onChange(newVolume)
                    }
            )
        }
        .frame(width: 20)
    }
}
