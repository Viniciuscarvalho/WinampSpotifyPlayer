//
//  MediaKeyHandler.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Cocoa
import Carbon

/// Handles macOS media key events (play/pause, next, previous)
final class MediaKeyHandler {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    var onPlayPause: (() -> Void)?
    var onNext: (() -> Void)?
    var onPrevious: (() -> Void)?

    func startMonitoring() {
        // Create event tap
        let eventMask = (1 << CGEventType.keyDown.rawValue)

        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else {
                    return Unmanaged.passRetained(event)
                }

                let handler = Unmanaged<MediaKeyHandler>.fromOpaque(refcon).takeUnretainedValue()
                return handler.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("Failed to create event tap for media keys")
            return
        }

        self.eventTap = eventTap

        // Create and add run loop source
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)

        // Enable the event tap
        CGEvent.tapEnable(tap: eventTap, enable: true)

        print("Media key monitoring started")
    }

    func stopMonitoring() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }

        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        }

        print("Media key monitoring stopped")
    }

    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        // Check if this is a media key event
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

        // Media key codes (from NSEvent) - use Int32 to match Carbon types
        switch Int32(keyCode) {
        case Int32(NX_KEYTYPE_PLAY): // Play/Pause
            onPlayPause?()
            return nil // Consume the event

        case Int32(NX_KEYTYPE_NEXT), Int32(NX_KEYTYPE_FAST): // Next track
            onNext?()
            return nil

        case Int32(NX_KEYTYPE_PREVIOUS), Int32(NX_KEYTYPE_REWIND): // Previous track
            onPrevious?()
            return nil

        default:
            break
        }

        return Unmanaged.passRetained(event)
    }
}
