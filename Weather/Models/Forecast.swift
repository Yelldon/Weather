//
//  Forecast.swift
//  Weather
//
//  Created by Greg Patrick on 7/4/22.
//

struct Forecast: Decodable {
    let properties: ForecastProperties
}

struct ForecastProperties: Decodable {
    let periods: [ForecastPeriod]
}
