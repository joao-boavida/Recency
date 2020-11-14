//
//  RecencyUITests.swift
//  RecencyUITests
//
//  Created by Joao Boavida on 12/10/2020.
//

import XCTest

// debug command to list what is avail to XCTest
// po print(XCUIApplication().debugDescription)

class RecencyUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testWelcomeScreen() {
        let getStartedButton = app.buttons["getStartedButton"]
        XCTAssert(getStartedButton.exists)

        getStartedButton.tap()

        let emptyLog = app.staticTexts["addActivitiesToBeginText"]

        XCTAssert(emptyLog.exists)
    }

    func testHomeScreen() throws {
        let getStartedButton = app.buttons["getStartedButton"]
        XCTAssert(getStartedButton.exists)

        getStartedButton.tap()

        let addActivityButton = app.buttons["addActivityButton"]
        XCTAssert(addActivityButton.exists)
    }

    func testAddActivity() throws {
        let getStartedButton = app.buttons["getStartedButton"]
        getStartedButton.tap()
        let addActivityButton = app.buttons["addActivityButton"]
        addActivityButton.tap()
        let doneButton = app.buttons["doneButton"]
        doneButton.tap()

        // An activity detail line is considered a button by XCTest because it is a navigationlink.
        let activityLine = app.buttons["takeoffs: 1 landings: 1"]
        XCTAssert(activityLine.exists)

    }

    func testSwipeDeleteMainScreen() throws {
        let getStartedButton = app.buttons["getStartedButton"]
        getStartedButton.tap()
        let addActivityButton = app.buttons["addActivityButton"]
        addActivityButton.tap()
        let doneButton = app.buttons["doneButton"]
        doneButton.tap()
        let activityLine = app.buttons["takeoffs: 1 landings: 1"]

        activityLine.swipeLeft()
        let deleteButton = app.buttons["Delete"]
        XCTAssert(deleteButton.exists)
        deleteButton.tap()
        XCTAssertFalse(activityLine.exists)
    }

    func testDeleteActivity() throws {
        let getStartedButton = app.buttons["getStartedButton"]
        getStartedButton.tap()
        let addActivityButton = app.buttons["addActivityButton"]
        addActivityButton.tap()
        let doneButton = app.buttons["doneButton"]
        doneButton.tap()
        let activityLine = app.buttons["takeoffs: 1 landings: 1"]
        activityLine.tap()

        let deleteButton = app.buttons["deleteActivityButton"]
        XCTAssert(deleteButton.exists)
        deleteButton.tap()

        let confirmDeleteButton = app.alerts.buttons["Delete"]
        XCTAssert(confirmDeleteButton.exists)
        confirmDeleteButton.tap()

        // the following text only appears if the activity list is empty
        let emptyLog = app.staticTexts["addActivitiesToBeginText"]
        XCTAssert(emptyLog.exists)

    }

    // missing UI Tests:
    //
    // - Modify activity
    // - swipe to delete on detail screen

    /*func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }*/
}
