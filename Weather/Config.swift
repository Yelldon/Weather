//
//  Config.swift
//  Weather
//
//  Created by Greg Patrick on 7/3/22.
//

import Foundation
import CoreLocation

class Config {
    static var state = AppState.shared
    
    static let baseApiUrl = "https://api.weather.gov"
    
    static func gridPointUrl(location: CLLocation) -> String {
        let latString = String(format: "%.4f", location.coordinate.latitude)
        let lonString = String(format: "%.4f", location.coordinate.longitude)
        
        return "\(baseApiUrl)/points/\(latString),\(lonString)"
    }
    
    static var observationUrl: String {
        if let station = state.stationData?.observationStations.first {
            return "\(station)/observations/latest"
        } else {
            return ""
        }
    }
}
