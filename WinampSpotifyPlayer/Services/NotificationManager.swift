//
//  NotificationManager.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import UserNotifications

/// Manages macOS notifications for track changes
final class NotificationManager: NSObject {
    static let shared = NotificationManager()

    private override init() {
        super.init()
        requestAuthorization()
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func showNowPlaying(track: Track) {
        let content = UNMutableNotificationContent()
        content.title = "Now Playing"
        content.subtitle = track.name
        content.body = track.artistNamesString
        content.sound = nil // Silent notification

        let request = UNNotificationRequest(
            identifier: "now-playing",
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }

    func clearNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
