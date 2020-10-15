//
//  RecencyTests.swift
//  RecencyTests
//
//  Created by Joao Boavida on 12/10/2020.
//

import XCTest
@testable import Recency

class RecencyTests: XCTestCase {

    override func setUpWithError() throws {
        let sampleFlightLog = FlightLog()

        // referenceDate

        var components = DateComponents()
        components.year = 2020
        components.month = 10
        components.day = 13
        //components.calendar = .current

        let referenceDate = Calendar.current.date(from: components)!

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
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
