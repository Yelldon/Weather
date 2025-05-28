//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Greg Patrick on 4/4/25.
//

import Foundation
import SwiftUI
import Testing
import XCTest

@testable import Weather

@Suite("Weather App Tests")
struct WeatherTests {

    // MARK: - Temperature Conversion Tests

    @Test("Celsius to Fahrenheit conversion works correctly")
    func testCtoFConversion() {
        // Test freezing point of water (0°C = 32°F)
        #expect(convertCToF(0) == 32, "0°C should convert to 32°F")

        // Test boiling point of water (100°C = 212°F)
        #expect(convertCToF(100) == 212, "100°C should convert to 212°F")

        // Test body temperature (37°C ≈ 99°F)
        #expect(convertCToF(37) == 99, "37°C should convert to 99°F")

        // Test negative temperature (-40°C = -40°F, the point where scales meet)
        #expect(convertCToF(-40) == -40, "-40°C should convert to -40°F")

        // Test fractional temperature (21.5°C ≈ 71°F)
        #expect(convertCToF(21.5) == 71, "21.5°C should convert to 71°F")
    }

    // MARK: - Time Formatting Tests

    @Test("Time formatting works correctly")
    func testTimeFormatting() {
        let testDate = "2025-04-15T14:30:00Z"
        let formattedTime = time(testDate)

        #expect(formattedTime != nil, "Time formatting should not return nil")
        if let formattedTime {
            #expect(formattedTime.contains(":"), "Formatted time should contain a colon")
        }
    }

    @Test("Hour extraction works correctly")
    func testHourExtraction() {
        let morningDate = "2025-04-15T08:30:00Z"
        let afternoonDate = "2025-04-15T14:30:00Z"

        let morningHour = hour(morningDate)
        let afternoonHour = hour(afternoonDate)

        #expect(morningHour != nil, "Morning hour should not be nil")
        #expect(morningHour?.contains("AM") == true, "Morning hour should contain AM")

        #expect(afternoonHour != nil, "Afternoon hour should not be nil")
        #expect(afternoonHour?.contains("PM") == true, "Afternoon hour should contain PM")
    }

    // MARK: - Icon Generation Tests

    @Test(
        "Weather icon generation works correctly",
        .disabled("Don't really have a good test for icons yet.")
    )
    func testIconViewGeneratedIcon() {
        _ = IconView(weather: "Sunny")
        _ = IconView(weather: "Cloudy")
        _ = IconView(weather: "Rain")
        _ = IconView(weather: nil)

        // This is a simplification - in reality we'd need to extract the SF Symbol name
        // from the View hierarchy, which is complex. In practice, you might refactor
        // the IconView to expose its generated icon for testing.

        // For demonstration purposes, assuming we can access the private generatedIcon property:
        // #expect(iconView1.generatedIcon == "sun.max.fill")
        // #expect(iconView2.generatedIcon == "cloud.fill")
        // #expect(iconView3.generatedIcon == "cloud.drizzle")
        // #expect(iconView4.generatedIcon == "sun.max.fill") // Default

        // Without refactoring, we can at least verify that different weather inputs
        // produce different views (not a strong test but better than nothing)
        // #expect(IconView(weather: "Sunny") != IconView(weather: "Cloudy"))
    }

    // MARK: - Model Tests

    @Test("SavedLocation creation works correctly")
    func testSavedLocation() {
        let UUID: UUID = UUID()
        let location = SavedLocation(
            id: UUID,
            city: "New York",
            state: "NY",
            lat: 40.7128,
            lon: -74.0060
        )

        #expect(location.city == "New York")
        #expect(location.state == "NY")
        #expect(location.lat == 40.7128)
        #expect(location.lon == -74.0060)
        #expect(location.id == UUID)
    }

    // MARK: - API Error Tests

    @Test(
        "API errors are handled correctly",
        .disabled("better error handling needs to happen for this to work well.")
    )
    func testApiErrorHandling() {
        _ = WeatherAPI.AppError.invalidURL
        _ = WeatherAPI.AppError.decodingFailed

        // #expect(invalidURLError is Error)
        // #expect(decodingFailedError is Error)
    }
}
