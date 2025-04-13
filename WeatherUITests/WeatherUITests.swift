//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Greg Patrick on 4/4/25.
//

import XCTest

final class WeatherUITests: XCTestCase {
    var app: XCUIApplication!
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    @MainActor
//    func appLaunch() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
    func testMainViewLoading() throws {
        // Test that main weather view loads properly
        XCTAssertTrue(app.otherElements["currentWeatherView"].exists)

        // Check for temperature display
        XCTAssertTrue(app.staticTexts.matching(identifier: "temperatureLabel").firstMatch.exists)
    }

    // Weather Menu Tests
    @MainActor
    func testLocationMenuNavigation() throws {
        // Open location menu
        app.buttons["locationMenuButton"].tap()

        // Verify menu appears
        XCTAssertTrue(app.otherElements["locationMenuView"].waitForExistence(timeout: 2))

        // Close menu
        app.swipeRight()  // Or tap outside to dismiss

        // Verify menu disappears
        XCTAssertFalse(app.otherElements["locationMenuView"].waitForExistence(timeout: 2))
    }
    
    // Locations Search Tests
    @MainActor
    func testLocationSearch() throws {
        // Open location menu
        app.buttons["locationMenuButton"].tap()

        // Tap search field
        app.textFields["searchField"].tap()

        // Type a city name
        app.typeText("New York")

        // Wait for search results
        let searchResults = app.tables.cells.firstMatch
        XCTAssertTrue(searchResults.waitForExistence(timeout: 5))

        // Tap on first result
        searchResults.tap()

        // Verify location changed
        let locationName = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "New York")
        ).firstMatch
        XCTAssertTrue(locationName.waitForExistence(timeout: 5))
    }
    
    // Saved Locations Tests
    @MainActor
    func testSavedLocationManagement() throws {
        // First add a location
        try? testLocationSearch()

        // Open location menu again
        app.buttons["locationMenuButton"].tap()

        // Verify saved location exists
        let savedLocation = app.buttons["New York"]
        XCTAssertTrue(savedLocation.exists)

        // Swipe to delete
        savedLocation.swipeLeft()

        // Tap delete button
        app.buttons["Delete"].tap()

        // Verify location was deleted
        XCTAssertFalse(app.buttons["New York"].exists)
    }

    // Weather Content Tests
    @MainActor
    func testHourlyForecastScrolling() throws {
        // Test horizontal scrolling in hourly forecast
        let hourlyForecast = app.scrollViews["hourlyForecastScrollView"]
        XCTAssertTrue(hourlyForecast.exists)

        // Swipe to scroll
        hourlyForecast.swipeLeft()

        // Verify scroll position changed (by checking for elements that should now be visible)
        // This depends on your implementation and how views are identified
        let laterHourForecast = hourlyForecast.otherElements.element(boundBy: 10)
        XCTAssertTrue(laterHourForecast.waitForExistence(timeout: 2))
    }

    // Error State Tests
    @MainActor
    func testExtendedForecastScrolling() throws {
        // Test extended forecast scrolling
        let extendedForecast = app.scrollViews["extendedForecastScrollView"]
        XCTAssertTrue(extendedForecast.exists)

        // Swipe to scroll
        extendedForecast.swipeLeft()

        // Verify forecast for future day is visible
        let futureForecast = extendedForecast.staticTexts.matching(
            NSPredicate(format: "label CONTAINS %@", "Tomorrow")
        ).firstMatch
        XCTAssertTrue(futureForecast.waitForExistence(timeout: 2))
    }
}
