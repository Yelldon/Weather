//
//  SavedLocation.swift
//  Weather
//
//  Created by Greg Patrick on 4/7/25.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class SavedLocation: Identifiable {
    var id: UUID = UUID()
    var city: String
    var state: String
    var lat: Double
    var lon: Double
    
    init(
        id: UUID = UUID(),
        city: String,
        state: String,
        lat: Double,
        lon: Double,
    ) {
        self.id = id
        self.city = city
        self.state = state
        self.lat = lat
        self.lon = lon
    }
}
