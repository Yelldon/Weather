//
//  Api.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation
import CoreLocation

@MainActor
class Api {
    static var state = AppState.shared
    static private let baseApiUrl = "https://api.weather.gov"
    
    static func getStatus() async -> Void {
        do {
            state.status = try await fetch(url: baseApiUrl, type: StatusModel.self)
        } catch {
            print("Home error occured")
            debugPrint(error)
        }
    }
    
    static func getPointData() async -> Void {
        do {
            if let location = state.location.lastLocation {
                state.pointData = try await fetch(url: gridPointUrl(location: location), type: GridPointsModel.self)
            }
        } catch {
            debugPrint("Get point data error occured")
            debugPrint(error)
        }
    }
    
    static func getStationData() async -> Void {
        do {
            if let stations = state.pointData?.properties.observationStations {
                state.stationData = try await fetch(url: stations, type: StationModel.self)
            }
        } catch {
            debugPrint("Get stations data error occured")
            debugPrint(error)
        }
    }
    
    static func getCurrentWeather() async -> Void {
        do {
            debugPrint("Get current weather")
            debugPrint(observationUrl)
            state.currentWeather = try await fetch(url: observationUrl, type: WeatherModel.self)
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
    
    static func getHourlyForecast() async -> Void {
        do {
            debugPrint("Get Hourly Forecast")
            if let forecastHourly = state.pointData?.properties.forecastHourly {
                state.hourlyForecast = try await fetch(url: forecastHourly, type: ForecastModel.self)
            }
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
    
    static func getExtendedForecast() async -> Void {
        do {
            if let forecast = state.pointData?.properties.forecast {
                state.extendedForecast = try await fetch(url: forecast, type: ForecastModel.self)
            }
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
    
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

private extension Api {
    static func fetch<T: Decodable>(url: String, type: T.Type) async throws -> T {
//        if let url = URL(string: url) {
            let url = URL(string: url)!
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            let decoder = JSONDecoder()
            
            return try decoder.decode(type, from: data)
//        } else {
//            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
//        }
    }
}
