//
//  Api.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation

@MainActor
class Api {
    static var state = AppState.shared
    
    static func getStatus() async -> Void {
        do {
            state.status = try await fetch(url: "https://api.weather.gov", type: StatusModel.self)
        } catch {
            print("Home error occured")
            debugPrint(error)
        }
    }
    
    static func getPointData() async -> Void {
        do {
            if let location = state.location.lastLocation {
                state.pointData = try await fetch(url: Config.gridPointUrl(location: location), type: GridPointsModel.self)
                
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
                debugPrint(state.stationData)
            }
        } catch {
            debugPrint("Get stations data error occured")
            debugPrint(error)
        }
    }
    
    static func getCurrentWeather() async -> Void {
        do {
            debugPrint("Get current weather")
            debugPrint(Config.observationUrl)
            state.currentWeather = try await fetch(url: Config.observationUrl, type: WeatherModel.self)
        } catch {
            debugPrint("Get current weather error occured")
            debugPrint(error)
        }
    }
}

private extension Api {
    static func fetch<T: Decodable>(url: String, type: T.Type) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: url)!))
        let decoder = JSONDecoder()
        
        return try decoder.decode(type, from: data)
    }
}
