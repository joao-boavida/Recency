import SwiftUI

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
    @Published var data = [FlightActivity]()

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
                print("checkTakeoffRecency limitingTakeoffDate: \(limitingTakeoffDate)")
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
                print("checkLandingRecency limitingLandingDate: \(limitingLandingDate)")
                return Calendar.current.date(byAdding: .day, value: 90, to: limitingLandingDate)!
            }
        }

        return Date.distantPast
    }
}

//testing

var sampleFlightLog = FlightLog()

// referenceDate

var components = DateComponents()
components.year = 2020
components.month = 10
components.day = 13
//components.calendar = .current

components.isValidDate

let referenceDate = Date()

let movement1 = FlightActivity(takeoffs: 1, takeoffDate: referenceDate, landings: 1, landingDate: referenceDate)

// 3 days ago
let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!

let movement2 = FlightActivity(takeoffs: 1, takeoffDate: threeDaysAgo, landings: 1, landingDate: threeDaysAgo)

// 30 days ago
let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: referenceDate)!

let movement3 = FlightActivity(takeoffs: 1, takeoffDate: thirtyDaysAgo, landings: 1, landingDate: thirtyDaysAgo)

// 100 days ago
let hundredDaysAgo = Calendar.current.date(byAdding: .day, value: -100, to: referenceDate)!

let movement4 = FlightActivity(takeoffs: 1, takeoffDate: hundredDaysAgo, landings: 1, landingDate: hundredDaysAgo)

sampleFlightLog.data.append(movement1)
sampleFlightLog.data.append(movement2)
sampleFlightLog.data.append(movement3)
sampleFlightLog.data.append(movement4)

print("take-off recency: \(sampleFlightLog.checkTakeoffRecency())")

print("landing recency: \(sampleFlightLog.checkLandingRecency())")

print("recency: \(sampleFlightLog.checkRecency())")
