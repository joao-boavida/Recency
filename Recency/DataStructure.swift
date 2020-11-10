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
}

/// This class is used to store an array of FlightActivity data as well as its storage key on UserDefaults
class FlightLog: ObservableObject {

    let flightActivityStorageKey = "FlightActivity"

    @Published var data: [FlightActivity] {
        didSet {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(data) {
                    UserDefaults.standard.set(encoded, forKey: flightActivityStorageKey)
                }
            }
        }

    /// Custom initialiser to get data from user defaults
    /// - Parameter emptyLog: if true an empty log will be created, for previewing and testing
    init(emptyLog: Bool = false) {

        guard emptyLog == false else {
            self.data = [FlightActivity]()

            return
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
                return
            }
        }
        /*self.firstRun = true*/
        self.data = []
    }

    /// This function adds an activity to the log
    /// - Parameter activity: the activity to be added
    func addActivity(activity: FlightActivity) {
        data.append(activity)
        data.sort {
            $1.activityDate < $0.activityDate
        }
    }

    /// This function checks recency validity (returned as a Bool) at a given date. The validity is extended up to the end of the day of that date in the current calendar.
    /// - Parameter date: date to be checked
    /// - Returns: validity as boolean
    func isRecencyValid(at date: Date) -> Bool {
        checkRecency() > date || Calendar.current.isDate(checkRecency(), inSameDayAs: date)
    }

    /// Checks the recency validity limit date of the current data structure
    /// - Returns: validity limit, distant past if unable to determine
    func checkRecency() -> Date {

        let takeoffRecencyDate = checkTakeoffRecency()

        let landingRecencyDate = checkLandingRecency()

        return min(landingRecencyDate, takeoffRecencyDate)

    }

    /// Checks the recency validity date of the takeoffs in the current data structure
    /// - Returns: takeoff validity limit, distant past if unable to determine
    func checkTakeoffRecency() -> Date {

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
    func checkLandingRecency() -> Date {
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
}
