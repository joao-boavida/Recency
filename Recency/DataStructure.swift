//
//  DataStructure.swift
//  Recency
//
//  Created by Joao Boavida on 13/10/2020.
//

import Foundation

/// The main data structure of the app, bundling one activity that may contain take-offs, landings or both as well as the associated date. insertionDate not used at the moment.
struct FlightActivity: Identifiable, Codable, Equatable {
    var id = UUID()
    var insertionDate = Date()
    let takeoffs: Int
    let activityDate: Date
    let landings: Int

    /// The formatted activity date
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self.activityDate)
    }

    #if DEBUG
    /// Used for UI Testing
    var shortDescription: String {
        "takeoffs: \(takeoffs) landings: \(landings)"
    }
    #endif
}

/// This enum specified the possible states of the user's local notification preferences
enum LocalNotificationPreferences: String, Codable {
    case allowed
    case denied
    case maybeLater
    case unknown
}

/// This class is used to store an array of FlightActivity data as well as its storage key on UserDefaults
class FlightLog: ObservableObject {

    /// Storage keys to try and avoid some of the pitfalls of the stringly typed UserDefaults API
    let flightActivityStorageKey = "FlightActivity"
    let localNotificationPreferencesStorageKey = "LocalNotificationPreferences"

    /// This array holds the user's flight activities; the private setter ensures this struct's functions must be used to access it to avoid corrupted data. The property observer ensures values are stored in user defaults.
    @Published private(set) var data: [FlightActivity] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(data) {
                UserDefaults.standard.set(encoded, forKey: flightActivityStorageKey)
            }
        }
    }

    /// This variable holds and stores (in user defaults) the user's local notification preferences. Local notification preferences are used to avoid probing Apple's user notification preferences in order to contextualise the notification request and support a "maybe later" option.
    @Published var localNotificationPreferences: LocalNotificationPreferences {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(localNotificationPreferences) {
                UserDefaults.standard.set(encoded, forKey: localNotificationPreferencesStorageKey)
            }
        }
    }

    /// Checks the recency validity limit date of the current data structure
    /// - Returns: validity limit, distant past if unable to determine
    var recencyValidity: Date {
        min(landingRecencyValidity, takeoffRecencyValidity)
    }

    /// Checks the recency validity date of the takeoffs in the current data structure
    /// - Returns: takeoff validity limit, distant past if unable to determine
    var takeoffRecencyValidity: Date {

        //sort the flight log by takeoff dates beginning with the most recent one
        let sortedFlightLog = data.sorted {
            $0.activityDate > $1.activityDate
        }

        var takeOffCount = 0
        var limitingTakeoffDate = Date()

        for movement in sortedFlightLog {
            takeOffCount += movement.takeoffs
            limitingTakeoffDate = movement.activityDate

            if takeOffCount > 2 {
                return Calendar.current.date(byAdding: .day, value: 90, to: limitingTakeoffDate)!
            }
        }

        return Date.distantPast
    }

    /// Checks the landing validity limit date of the current data structure
    /// - Returns: landing validity limit, distant past if unable to determine
    var landingRecencyValidity: Date {
        let sortedFlightLog = data.sorted {
            $0.activityDate > $1.activityDate
        }

        var landingCount = 0
        var limitingLandingDate = Date()

        for movement in sortedFlightLog {
            landingCount += movement.landings
            limitingLandingDate = movement.activityDate

            if landingCount > 2 {
                return Calendar.current.date(byAdding: .day, value: 90, to: limitingLandingDate)!
            }
        }

        return Date.distantPast
    }

    /// Custom initialiser to get data from user defaults
    /// - Parameter emptyLog: if true an empty log will be created, for previewing and testing
    init(emptyLog: Bool = false) {

        self.data = []
        self.localNotificationPreferences = .unknown

        guard emptyLog == false else { return }

        if let notificationPreferencesData = UserDefaults.standard.data(forKey: localNotificationPreferencesStorageKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(LocalNotificationPreferences.self, from: notificationPreferencesData) {
                self.localNotificationPreferences = decoded
            }
        }

        if let data = UserDefaults.standard.data(forKey: flightActivityStorageKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([FlightActivity].self, from: data) {
                self.data = decoded
                //data more than 6months old is discarded
                let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? .distantPast
                self.data = self.data.filter {
                    $0.activityDate > sixMonthsAgo
                }
            }
        }
    }

    /// This function adds an activity to the log
    /// - Parameter activity: the activity to be added
    func addActivity(activity: FlightActivity) {

        // correct the time to 12:00 UTC to avoid time zone problems

        let calendar = Calendar.current
        var components = calendar.dateComponents(in: .current, from: activity.activityDate)

        components.hour = 12
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        components.timeZone = TimeZone(identifier: "UTC")

        // the date should never be invalid; however if it is then the system defaults to the insertiondate
        let correctedDate = components.date ?? activity.activityDate

        let correctedActivity = FlightActivity(id: activity.id, insertionDate: activity.insertionDate, takeoffs: activity.takeoffs, activityDate: correctedDate, landings: activity.landings)

        data.append(correctedActivity)
        // if the activity date is different, which means different days as the time is always 1200Z, sort by activity date; otherwise, sort by insertion date.
        data.sort {
            if $1.activityDate != $0.activityDate {
                return $1.activityDate < $0.activityDate
            } else {
                return $1.insertionDate < $0.insertionDate
            }
        }

        // update the local user notifications if recent now and local notifications shows allowed

        if isRecencyValid(at: Date()) && localNotificationPreferences == .allowed {
            NotificationsManager.scheduleNotificationsFromRecencyDate(recencyDate: recencyValidity)
        }
    }

    /// Errors regarding the database
    enum DataErrors: Error {
        case notFound
    }

    /// removes a given activity from the database, throws an error if not found.
    /// - Parameter activity: the activity to be removed
    /// - Throws: an error if the activity was not in the database
    func removeActivity(activity: FlightActivity) throws {
        if let index = data.firstIndex(of: activity) {
            data.remove(at: index)

            // update the local user notifications if recent now, clear them if the recency just became invalid
            if localNotificationPreferences == .allowed {
                if isRecencyValid(at: Date()) {
                    NotificationsManager.scheduleNotificationsFromRecencyDate(recencyDate: recencyValidity)
                } else {
                    NotificationsManager.removePendingNotifications()
                }
            }

        } else {
            throw DataErrors.notFound
        }
    }

    /// removes the activity at a given indexset; for use with the swipe to delete gestures in the foreach rows
    /// - Parameter offsets: offsets sent by the swipe to delete command
    func removeActivity(at offsets: IndexSet) {
        data.remove(atOffsets: offsets)

        // update the local user notifications if recent now, clear them if the recency just became invalid
        if localNotificationPreferences == .allowed {
            if isRecencyValid(at: Date()) {
                NotificationsManager.scheduleNotificationsFromRecencyDate(recencyDate: recencyValidity)
            } else {
                NotificationsManager.removePendingNotifications()
            }
        }

    }

    #if DEBUG
    /// Used by the internal testing suite to clear the activity log
    internal func clearLog() {
        data = []
    }
    #endif

    /// This function checks recency validity (returned as a Bool) at a given date. The validity is extended up to the end of the day of that date in the current calendar.
    /// - Parameter date: date to be checked
    /// - Returns: validity as boolean
    func isRecencyValid(at date: Date) -> Bool {
        recencyValidity > date || Calendar.current.isDate(recencyValidity, inSameDayAs: date)
    }

    /// This function checks takeoff recency validity (returned as a Bool) at a given date. The validity is extended up to the end of the day of that date in the current calendar.
    /// - Parameter date: date to be checked
    /// - Returns: validity as boolean
    func areTakeoffsValid(at date: Date) -> Bool {
        takeoffRecencyValidity > date || Calendar.current.isDate(takeoffRecencyValidity, inSameDayAs: date)
    }

    /// This function checks landing recency validity (returned as a Bool) at a given date. The validity is extended up to the end of the day of that date in the current calendar.
    /// - Parameter date: date to be checked
    /// - Returns: validity as boolean
    func areLandingsValid(at date: Date) -> Bool {
        landingRecencyValidity > date || Calendar.current.isDate(landingRecencyValidity, inSameDayAs: date)
    }

}
