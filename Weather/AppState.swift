//
//  AppState.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation
import Combine
import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var location = LocationManager()
    @Published var status = StatusModel(status: "----")
    @Published var pointData: GridPointsModel?
    @Published var stationData: StationModel?
    @Published var currentWeather: WeatherModel?
}
