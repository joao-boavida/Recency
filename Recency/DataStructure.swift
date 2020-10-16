//
//  DataStructure.swift
//  Recency
//
//  Created by Joao Boavida on 13/10/2020.
//

import Foundation

struct FlightActivity: Identifiable, Codable {
    var id = UUID()
    var insertionDate = Date()
    let takeoffs: Int
    let activityDate: Date
    let landings: Int
}

class FlightLog: ObservableObject {

    let storageKey = "FlightActivity"

    @Published var data: [FlightActivity] {
        didSet {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(data) {
                    UserDefaults.standard.set(encoded, forKey: storageKey)
                }
            }
        }

    init(emptyLog: Bool = false) {

        guard emptyLog == false else { //used for testing and previews
            self.data = [FlightActivity]()
            return
        }

        if let data = UserDefaults.standard.data(forKey: storageKey) {
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
        self.data = []
    }

    func addActivity(activity: FlightActivity) {
        data.append(activity)
        data.sort {
            $1.activityDate < $0.activityDate
        }
    }

    func isRecencyValid(at date: Date) -> Bool {
        checkRecency() > date || Calendar.current.isDate(checkRecency(), inSameDayAs: date)
    }

    func checkRecency() -> Date {

        let takeoffRecencyDate = checkTakeoffRecency()

        let landingRecencyDate = checkLandingRecency()

        return min(landingRecencyDate, takeoffRecencyDate)

    }

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
                //print("checkTakeoffRecency limitingTakeoffDate: \(limitingTakeoffDate)")
                return Calendar.current.date(byAdding: .day, value: 90, to: limitingTakeoffDate)!
            }
        }

        return Date.distantPast
    }

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
                //print("checkLandingRecency limitingLandingDate: \(limitingLandingDate)")
                return Calendar.current.date(byAdding: .day, value: 90, to: limitingLandingDate)!
            }
        }

        return Date.distantPast
    }
}
