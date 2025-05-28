//
//  WeatherProperties.swift
//  Weather
//
//  Created by Greg Patrick on 5/18/25.
//

struct WeatherProperties: Decodable {
    let timestamp: String
    let textDescription: String
    let temperature: WeatherValues
    let heatIndex: WeatherValues
}
