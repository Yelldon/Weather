//
//  IconView.swift
//  Weather
//
//  Created by Greg Patrick on 4/6/25.
//

import SwiftUI

struct IconView: View {
    var weather: String?
    
    var body: some View {
        ZStack {
            iconView
        }
    }
}

// MARK: Properties
private extension IconView {
    var generatedIcon: String {
        guard let weather, !weather.isEmpty else {
            return "sun.max.fill"
        }
        
        // There is quite a few more options!
        // But seeing as that the the API doesn't document the possible
        // options, just mostly finding them by trial and error.
        if weather.contains("Mostly Sunny") {
            return "cloud.sun"
        } else if weather.contains("Sunny") {
            return "sun.max.fill"
        } else if weather.contains("Cloudy") {
            return "cloud.fill"
        } else if weather.contains("Rain") {
            return "cloud.drizzle"
        } else if weather.contains("Frost") {
            return "thermometer.and.liquid.waves.snowflake"
        } else {
            return "sun.max.fill"
        }
    }
}

// MARK: Views
private extension IconView {
    var iconView: some View {
        Image(systemName: generatedIcon)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    IconView()
}
