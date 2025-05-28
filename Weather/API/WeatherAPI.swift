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
    
    func getPointData(for location: CLLocation) async throws -> GridPoints? {
        do {
            debugPrint("Getting grid point data")
            debugPrint(location)
            state.isWeatherViewLoading = true
            
            return try await fetch(from: gridPointUrl(location: location))
        } catch {
            debugPrint("Getting grid point data error occured")
            debugPrint(error)
            state.errorState.appError = .invalidURL
            
            return nil
        }
    }
    
    func getStationData(for stations: String) async throws -> Station? {
        do {
            debugPrint("Getting weather station data")
            debugPrint(stations)
            return try await fetch(from: stations)
        } catch {
            debugPrint("Getting weather station data error occured")
            debugPrint(error)
            state.errorState.appError = .invalidURL
            
            return nil
        }
    }
    
    func getCurrentWeather(for observationUrl: String) async throws {
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
    
    func getHourlyForecast(for pointData: GridPoints) async throws {
        let forecastHourly = pointData.properties.forecastHourly
        do {
            debugPrint("Getting Hourly Forecast")
            debugPrint(forecastHourly)
            state.hourlyForecast = try await fetch(from: forecastHourly)
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
    
    func getExtendedForecast(for pointData: GridPoints) async throws {
        let forecast = pointData.properties.forecast
        do {
            debugPrint("Getting Hourly Forecast")
            debugPrint(forecast)
            state.extendedForecast = try await fetch(from: forecast)
        } catch {
            debugPrint("Getting Hourly Forecast error occured")
            debugPrint(error)
        }
    }
    
    func getLocationUpdate(location: CLLocation?) async throws {
        if let location {
            state.locationManager.stopLocationUpdates()
            
            let pointData = try await Task {
                try await WeatherAPI.shared.getPointData(for: location)
            }.value
            
            let stationData = try await Task {
                if let pointData {
                    return try await WeatherAPI.shared.getStationData(for: pointData.properties.observationStations)
                } else {
                    return nil
                }
            }.value
            
            Task {
                if let pointData, let stationData {
                    await WeatherAPI.shared.getWeatherInfo(
                        for: WeatherLocationResult(pointData: pointData, stationData: stationData)
                    )
                }
            }
        } else {
            state.errorState.setAppError(.locationFailed)
        }
    }
    
    func getWeatherInfo(for data: WeatherLocationResult) async {
        Task {
            try? await WeatherAPI.shared.getCurrentWeather(
                for: observationUrl(for: data.stationData.observationStations)
            )
        }
        
        Task {
            try? await WeatherAPI.shared.getHourlyForecast(for: data.pointData)
        }
        
        Task {
            try? await WeatherAPI.shared.getExtendedForecast(for: data.pointData)
        }
    }
}

// MARK: Weather API Errors
extension WeatherAPI {
    enum AppError: Error, Equatable {
        case decodingFailed
        case invalidURL
        case invalidResponse
        case invalidData
        case locationFailed
        case requestFailed(Error)
        
        static func == (lhs: WeatherAPI.AppError, rhs: WeatherAPI.AppError) -> Bool {
            lhs.localizedDescription == rhs.localizedDescription
        }
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
            throw AppError.requestFailed(error)
        }
    }
}

private extension WeatherAPI {
    func observationUrl(for stations: [String]) -> String {
        if let station = stations.first {
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
