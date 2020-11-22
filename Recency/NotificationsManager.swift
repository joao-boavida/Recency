//
//  NotificationsManager.swift
//  Recency
//
//  Created by Joao Boavida on 17/11/2020.
//

import Foundation
import UserNotifications

struct NotificationsManager {

    static let expiringNotificationTitle = "Recent Experience Expiring Today"
    static let expiringNotificationSubtitle = "You may not have valid recent experience by tomorrow"

    static let warningNotificationTitle = "Recent Experience Expiring in 14 days"
    static let warningNotificationSubtitle = "Add recent flights to update expiry date."

    static let center = UNUserNotificationCenter.current()

    static func requestPermission() {

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

            if let error = error {
                print(error.localizedDescription) // for debug
            }

            print("Current Authorisation status: \(granted)")

        }

    }

    static func scheduleNotificationAtDate(title: String, subtitle: String, date: Date) {

        let dateComponents = Calendar.current.dateComponents(in: .current, from: date)

        let content = UNMutableNotificationContent()

        content.title = title
        content.subtitle = subtitle
        content.sound = .default

        // the simplified date components variable holds a stripped down version of the original dateComponents generated from the user provided date. This simplified variable is used to set the notification trigger, as the original dateComponents do not work.

        var simplifiedComponents = DateComponents()
        simplifiedComponents.year = dateComponents.year
        simplifiedComponents.month = dateComponents.month
        simplifiedComponents.day = dateComponents.day
        simplifiedComponents.hour = 12

        let trigger = UNCalendarNotificationTrigger(dateMatching: simplifiedComponents, repeats: false)
        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    static func scheduleNotificationInSeconds(title: String, subtitle: String, interval: Int) {
        let content = UNMutableNotificationContent()

        content.title = title
        content.subtitle = subtitle
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)

    }

    static func scheduleNotificationsFromRecencyDate(recencyDate: Date) {

        scheduleNotificationAtDate(title: expiringNotificationTitle, subtitle: expiringNotificationSubtitle, date: recencyDate)

        let reminderDate = Calendar.current.date(byAdding: .day, value: -14, to: recencyDate)

        if let reminderDate = reminderDate {
            scheduleNotificationAtDate(title: warningNotificationTitle, subtitle: warningNotificationSubtitle, date: reminderDate)
        }

    }

    static func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    #if DEBUG

    static func printPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print(request)
            }
        }
    }

    #endif

}
