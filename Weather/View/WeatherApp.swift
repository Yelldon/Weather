//
//  WeatherApp.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import SwiftUI
import SwiftData

@main
struct WeatherApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedLocationModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            BaseView()
        }
        .modelContainer(sharedModelContainer)
    }
}

extension WeatherApp {
    
}
