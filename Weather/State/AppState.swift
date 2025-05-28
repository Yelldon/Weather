//
//  AppState.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation
import Observation

@Observable
class AppState {
    static let shared = AppState()
    
    var currentSavedSelection: SavedLocation?
    
    var locationManager = LocationManager()
    var locationState = LocationState()
    var errorState = ErrorState()

    var currentWeather: Weather?
    var hourlyForecast: Forecast?
    var extendedForecast: Forecast?
    
    var menuIsOpen: Bool = false
    var isWeatherViewLoading: Bool = false
}

extension AppState {
    func resetCurrentSelection() {
        isWeatherViewLoading = true
        currentSavedSelection = nil
    }
    
    func resetBaseState() {
        isWeatherViewLoading = true
        currentWeather = nil
        hourlyForecast = nil
        extendedForecast = nil
    }
}
