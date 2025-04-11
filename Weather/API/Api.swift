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
    
    static func getPointData(for location: CLLocation) async -> Void {
        do {
            debugPrint("Getting grid point data")
            debugPrint(location)
            state.pointData = try await fetch(from: gridPointUrl(location: location))
            state.isWeatherViewLoading = true
        } catch {
            debugPrint("Getting grid point data error occured")
            debugPrint(error)
            state.errorState.appError = .invalidURL
        }
    }
    
    static func getStationData() async -> Void {
        do {
            debugPrint("Getting weather station data")
            if let stations = state.pointData?.properties.observationStations {
                debugPrint(stations)
                state.stationData = try await fetch(from: stations)
            }
        } catch {
            debugPrint("Getting weather station data error occured")
            debugPrint(error)
            state.errorState.appError = .invalidURL
        }
    }
    
    static func getCurrentWeather() async -> Void {
        do {
            debugPrint("Getting current weather")
            debugPrint(observationUrl)
            state.currentWeather = try await fetch(from: observationUrl)
            state.isWeatherViewLoading = false
        } catch {
            debugPrint("Getting current weather error occured")
            debugPrint(error)
        }
    }
    
    static func getHourlyForecast() async -> Void {
        do {
            debugPrint("Getting Hourly Forecast")
            if let forecastHourly = state.pointData?.properties.forecastHourly {
                debugPrint(forecastHourly)
                state.hourlyForecast = try await fetch(from: forecastHourly)
            }
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
    
    static func getExtendedForecast() async -> Void {
        do {
            debugPrint("Getting Hourly Forecast")
            if let forecast = state.pointData?.properties.forecast {
                debugPrint(forecast)
                state.extendedForecast = try await fetch(from: forecast)
            }
        } catch {
            debugPrint("Getting Hourly Forecast error occured")
            debugPrint(error)
        }
    }
}

extension Api {
    enum AppError: Error {
        case decodingFailed
        case invalidURL
        case invalidResponse
        case invalidData
        case locationFailed
        case requestFailed
    }
}

private extension Api {
    static func fetch<T: Decodable>(from url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw AppError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw AppError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw AppError.decodingFailed
            }
        } catch {
            throw AppError.requestFailed
        }
    }
    
    static var observationUrl: String {
        if let station = state.stationData?.observationStations.first {
            return "\(station)/observations/latest"
        } else {
            return ""
        }
    }
    
    static func gridPointUrl(location: CLLocation) -> String {
        let latString = String(format: "%.4f", location.coordinate.latitude)
        let lonString = String(format: "%.4f", location.coordinate.longitude)
        
        return "\(baseApiUrl)/points/\(latString),\(lonString)"
    }
}
