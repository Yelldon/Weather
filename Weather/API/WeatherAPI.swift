//
//  Api.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation
import CoreLocation
import Observation

class WeatherAPI {
    static let shared = WeatherAPI()
    
    private let baseApiUrl = "https://api.weather.gov"
    
    var state = AppState.shared
    
    func getPointData(for location: CLLocation) async throws -> Void {
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
    
    func getStationData() async throws {
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
    
    func getCurrentWeather() async throws {
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
    
    func getHourlyForecast() async throws {
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
    
    func getExtendedForecast() async throws {
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
    
    func getLocationUpdate(location: CLLocation?) async {
        if let location {
            Task {
                try await WeatherAPI.shared.getPointData(for: location)
                try await WeatherAPI.shared.getStationData()
                
                let _ = try await WeatherAPI.shared.getCurrentWeather()
                let _ = try await WeatherAPI.shared.getHourlyForecast()
                let _ = try await WeatherAPI.shared.getExtendedForecast()
                
                state.locationManager.stopLocationUpdates()
            }
        } else {
            state.errorState.setAppError(.locationFailed)
        }
    }
}

extension WeatherAPI {
    enum AppError: Error {
        case decodingFailed
        case invalidURL
        case invalidResponse
        case invalidData
        case locationFailed
        case requestFailed
    }
}

private extension WeatherAPI {
    func fetch<T: Decodable>(from url: String) async throws -> T {
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
    
    var observationUrl: String {
        if let station = state.stationData?.observationStations.first {
            return "\(station)/observations/latest"
        } else {
            return ""
        }
    }
    
    func gridPointUrl(location: CLLocation) -> String {
        let latString = String(format: "%.4f", location.coordinate.latitude)
        let lonString = String(format: "%.4f", location.coordinate.longitude)
        
        return "\(baseApiUrl)/points/\(latString),\(lonString)"
    }
}
