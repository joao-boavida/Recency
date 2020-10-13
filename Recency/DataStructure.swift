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
    let takeoffDate: Date
    let landings: Int
    let landingDate: Date
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

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([FlightActivity].self, from: data) {
                self.data = decoded
                return
            }
        }
        self.data = []
    }

    func checkRecency() -> Date {

        let takeoffRecencyDate = checkTakeoffRecency()

        let landingRecencyDate = checkLandingRecency()

        return min(landingRecencyDate, takeoffRecencyDate)

    }

    func checkTakeoffRecency() -> Date {

        //sort the flight log by takeoff dates beginning with the most recent one
        let sortedFlightLog = data.sorted {
            $0.takeoffDate > $1.takeoffDate
        }

        var takeOffCount = 0
        var limitingTakeoffDate = Date()

        for movement in sortedFlightLog {
            takeOffCount += movement.takeoffs
            limitingTakeoffDate = movement.takeoffDate

            if takeOffCount > 2 {
                //print("checkTakeoffRecency limitingTakeoffDate: \(limitingTakeoffDate)")
                return Calendar.current.date(byAdding: .day, value: 90, to: limitingTakeoffDate)!
            }
        }

        return Date.distantPast
    }

    func checkLandingRecency() -> Date {
        let sortedFlightLog = data.sorted {
            $0.landingDate > $1.landingDate
        }

        var landingCount = 0
        var limitingLandingDate = Date()

        for movement in sortedFlightLog {
            landingCount += movement.landings
            limitingLandingDate = movement.landingDate

            if landingCount > 2 {
                //print("checkLandingRecency limitingLandingDate: \(limitingLandingDate)")
                return Calendar.current.date(byAdding: .day, value: 90, to: limitingLandingDate)!
            }
        }

        return Date.distantPast
    }
}
