//
//  WeatherModel.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

struct WeatherModel: Decodable {
    let properties: WeatherProperties
}

struct WeatherProperties: Decodable {
    let timestamp: String
    let textDescription: String
    let temperature: WeatherValues
    let heatIndex: WeatherValues
}

struct WeatherValues: Decodable {
    let unitCode: String
    let value: Double?
    let qualityControl: String?
}

