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
            state.status = try await fetch(from: baseApiUrl)
        } catch {
            print("Home error occured")
            debugPrint(error)
        }
    }
    
    static func getPointData(for location: CLLocation) async -> Void {
        do {
            state.pointData = try await fetch(from: gridPointUrl(location: location))
        } catch {
            debugPrint("Get point data error occured")
            debugPrint(error)
        }
    }
    
    static func getStationData() async -> Void {
        do {
            if let stations = state.pointData?.properties.observationStations {
                state.stationData = try await fetch(from: stations)
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
            state.currentWeather = try await fetch(from: observationUrl)
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
    
    static func getHourlyForecast() async -> Void {
        do {
            debugPrint("Get Hourly Forecast")
            if let forecastHourly = state.pointData?.properties.forecastHourly {
                state.hourlyForecast = try await fetch(from: forecastHourly)
            }
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
    
    static func getExtendedForecast() async -> Void {
        do {
            if let forecast = state.pointData?.properties.forecast {
                state.extendedForecast = try await fetch(from: forecast)
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
    static func fetch<T: Decodable>(from url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case invalidData
        case decodingFailed(Error)
    }
}
