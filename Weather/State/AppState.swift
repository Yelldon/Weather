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
    
    var location = LocationManager()
    
    var locationState = LocationState()
    var status = StatusModel(status: "----")
    var pointData: GridPointsModel?
    var stationData: StationModel?
    var currentWeather: WeatherModel?
    var hourlyForecast: ForecastModel?
    var extendedForecast: ForecastModel?
}
