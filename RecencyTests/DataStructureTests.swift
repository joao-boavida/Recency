//
//  RecencyTests.swift
//  RecencyTests
//
//  Created by Joao Boavida on 12/10/2020.
//

import XCTest
@testable import Recency

class RecencyTests: XCTestCase {

    var sut: FlightLog!
    var referenceDate: Date!

    override func setUp() {
        super.setUp()

        sut = FlightLog(emptyLog: true)

        var components = DateComponents()
        components.year = 2020
        components.month = 10
        components.day = 13
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        components.timeZone = TimeZone(identifier: "UTC")
        //components.calendar = .current
        referenceDate = Calendar.current.date(from: components)!

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sut = nil
        referenceDate = nil
    }

    func testAddActivity() {
        // Append 2 activities that then get sorted. assert the correct sorting.

        //let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)
        let movement1 = FlightActivity(id: UUID(), insertionDate: referenceDate, takeoffs: 1, activityDate: referenceDate, landings: 1)

        // 3 days ago
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!

        //let movement2 = FlightActivity(takeoffs: 1, activityDate: threeDaysAgo, landings: 1)
        let movement2 = FlightActivity(id: UUID(), insertionDate: threeDaysAgo, takeoffs: 1, activityDate: threeDaysAgo, landings: 1)

        sut.addActivity(activity: movement2)
        sut.addActivity(activity: movement1)

        let correctData = [movement1, movement2]

        XCTAssertEqual(sut.data, correctData)
    }

    func testRemoveActivity1() {
        let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)
        sut.addActivity(activity: movement1)
        try? sut.removeActivity(activity: movement1)
        XCTAssertTrue(sut.data.isEmpty)
    }

    func testRemoveActivity2() {
        let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)
        sut.addActivity(activity: movement1)
        sut.removeActivity(at: IndexSet(integer: 0))
        XCTAssertTrue(sut.data.isEmpty)
    }

    func testIsRecencyValid() {

        var components = DateComponents()
        components.year = 2021
        components.month = 01
        components.day = 08

        let checkDate = Calendar.current.date(from: components)!

        //recency limited by landings
        let movement1 = FlightActivity(takeoffs: 3, activityDate: referenceDate, landings: 1)
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!
        let movement2 = FlightActivity(takeoffs: 1, activityDate: threeDaysAgo, landings: 3)

        sut.addActivity(activity: movement2)
        sut.addActivity(activity: movement1)

        //let correctRecency = Calendar.current.date(byAdding: .day, value: 90, to: threeDaysAgo)

        XCTAssertTrue(sut.isRecencyValid(at: checkDate))

    }

    func testRecencyValidity() {

        //recency limited by landings
        let movement1 = FlightActivity(takeoffs: 3, activityDate: referenceDate, landings: 1)
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!
        let movement2 = FlightActivity(takeoffs: 1, activityDate: threeDaysAgo, landings: 3)

        sut.addActivity(activity: movement2)
        sut.addActivity(activity: movement1)

        let correctRecency = Calendar.current.date(byAdding: .day, value: 90, to: threeDaysAgo)

        XCTAssertEqual(sut.recencyValidity, correctRecency)

        //recency limited by takeoffs
        sut.clearLog()
        //sut.data = []
        let movement3 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 3)
        let movement4 = FlightActivity(takeoffs: 3, activityDate: threeDaysAgo, landings: 1)

        sut.addActivity(activity: movement3)
        sut.addActivity(activity: movement4)

        XCTAssertEqual(sut.recencyValidity, correctRecency)

    }

    func testTakeoffRecency() {
        let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!
        let movement2 = FlightActivity(takeoffs: 1, activityDate: threeDaysAgo, landings: 1)

        sut.addActivity(activity: movement2)
        sut.addActivity(activity: movement1)

        XCTAssertEqual(sut.takeoffRecencyValidity, .distantPast)

        sut.clearLog()
        //sut.data = []

        let movement3 = FlightActivity(takeoffs: 3, activityDate: referenceDate, landings: 1)

        sut.addActivity(activity: movement3)

        let correctRecency = Calendar.current.date(byAdding: .day, value: 90, to: referenceDate)

        XCTAssertEqual(sut.takeoffRecencyValidity, correctRecency)

    }

    func testLandingRecency() {
        let movement1 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 1)
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: referenceDate)!
        let movement2 = FlightActivity(takeoffs: 1, activityDate: threeDaysAgo, landings: 1)

        sut.addActivity(activity: movement2)
        sut.addActivity(activity: movement1)

        XCTAssertEqual(sut.landingRecencyValidity, .distantPast)

        sut.clearLog()
        //sut.data = []

        let movement3 = FlightActivity(takeoffs: 1, activityDate: referenceDate, landings: 3)

        sut.addActivity(activity: movement3)

        let correctRecency = Calendar.current.date(byAdding: .day, value: 90, to: referenceDate)

        XCTAssertEqual(sut.landingRecencyValidity, correctRecency)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
