//
//  NotificationsManager.swift
//  Recency
//
//  Created by Joao Boavida on 17/11/2020.
//

import Foundation
import UserNotifications

/// This type andles code to interact with the UserNotifications framework. All methods and variables are static.
struct NotificationsManager {

    // These strings hold the text used in the notifications. The Expiring notification is given on the expiry date while the warning notification is issued 14 days earlier.
    static let expiringNotificationTitle = "Recent Experience Expiring Today"
    static let expiringNotificationSubtitle = "You may not have valid recent experience by tomorrow"

    static let warningNotificationTitle = "Recent Experience Expiring in 14 days"
    static let warningNotificationSubtitle = "Add recent flights to update expiry date."

    static let center = UNUserNotificationCenter.current()

    /// Schedules a notification at 12:00 at a given day.
    /// - Parameters:
    ///   - title: notification title
    ///   - subtitle: notification subtitle
    ///   - date: the date at which the notification should be delivered
    ///   - badge: the number to badge the app icon with
    static func scheduleNotificationAtDate(title: String, subtitle: String, date: Date, badge: NSNumber = 0) {

        let dateComponents = Calendar.current.dateComponents(in: .current, from: date)

        let content = UNMutableNotificationContent()

        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        content.badge = badge

        // the simplified date components variable holds a stripped down version of the original dateComponents generated from the user provided date. This simplified variable is used to set the notification trigger, as the original dateComponents do not work.

        var simplifiedComponents = DateComponents()
        simplifiedComponents.year = dateComponents.year
        simplifiedComponents.month = dateComponents.month
        simplifiedComponents.day = dateComponents.day
        simplifiedComponents.hour = 12

        let trigger = UNCalendarNotificationTrigger(dateMatching: simplifiedComponents, repeats: false)
        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request)

    }

    /// Schedule warning and validity notifications from a given recency date, requesting user authorisation from apple's framework on the way.
    /// - Parameter recencyDate: recency date to generate the notification dates from
    static func scheduleNotificationsFromRecencyDate(recencyDate: Date) {

        center.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                //asynchronous as the system may have to wait for user answer
                //in xcode sim this fails to work the first time the app requests user authorisation, however it works fine on an actual iPhone. In the simulator if a debug breakpoint is set somewhere in this closure it also works fine, so it should be an xcode problem.

                removePendingNotifications()
                scheduleNotificationAtDate(title: expiringNotificationTitle, subtitle: expiringNotificationSubtitle, date: recencyDate, badge: 1)
                if let reminderDate = Calendar.current.date(byAdding: .day, value: -14, to: recencyDate) {
                    scheduleNotificationAtDate(title: warningNotificationTitle, subtitle: warningNotificationSubtitle, date: reminderDate)
                }

            } else if let error = error {
                print(error.localizedDescription)
            }
        }

    }

    /// Clears pending notifications.
    static func removePendingNotifications() {
       center.removeAllPendingNotificationRequests()
    }

    #if DEBUG

    /// Schedules a notification a given amount of seconds in the future. Used for development.
    /// - Parameters:
    ///   - title: notification title
    ///   - subtitle: notification subtitle
    ///   - interval: number of seconds to go until the notification
    ///   - badge: number to badge the app icon with
    static func scheduleNotificationInSeconds(title: String, subtitle: String, interval: Int, badge: NSNumber = 0) {
        let content = UNMutableNotificationContent()

        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        content.badge = badge

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
        let identifier = UUID().uuidString

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)

    }

    /// Prints pending notifications to the debugger console. used for development.
    static func printPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if requests.isEmpty {
                print("No pending notifications.")
            } else {
                for request in requests {
                    print(request)
                }
                print("Total scheduled notifications: \(requests.count)")
            }
        }
    }

    /// schedules a warning and an expiry notification 5 and 10 seconds from now, used for testing.
    static func testStandardNotifications() {
        scheduleNotificationInSeconds(title: warningNotificationTitle, subtitle: warningNotificationSubtitle, interval: 5)
        scheduleNotificationInSeconds(title: expiringNotificationTitle, subtitle: expiringNotificationSubtitle, interval: 10, badge: 1)
    }

    #endif

}
