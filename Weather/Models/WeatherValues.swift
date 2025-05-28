//
//  WeatherValues.swift
//  Weather
//
//  Created by Greg Patrick on 5/18/25.
//

struct WeatherValues: Decodable {
    let unitCode: String
    let value: Double?
    let qualityControl: String?
}
