//
//  Notification.swift
//  TimeToDo
//
//  Created by Minho on 3/9/24.
//

import Foundation
import UserNotifications

final class Notification {
    
    static let shared = Notification()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    private init() {}

    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }

    func sendNotification(title: String, body: String, seconds: Double, notificationIdentifier: String) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = title
        notificationContent.body = body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier,
                                            content: notificationContent,
                                            trigger: trigger)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }

    func removeNotification(notificationIdentifiers: [String]) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: notificationIdentifiers)
    }
}
