//
//  AppState.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation
import Combine
import SwiftUI

@Observable
class AppState {
    static let shared = AppState()
    
    var currentSavedSelection: SavedLocationModel?
    
//    var location = LocationManager()
//    
    var locationState = LocationState()
    
//    var status = StatusModel(status: "----")
    
    var pointData: GridPointsModel?
    var stationData: StationModel?
    var currentWeather: WeatherModel?
    var hourlyForecast: ForecastModel?
    var extendedForecast: ForecastModel?
    
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
        pointData = nil
        stationData = nil
        currentWeather = nil
        hourlyForecast = nil
        extendedForecast = nil
    }
}
