//
//  ForecastPeriodModel.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

struct ForecastPeriodModel: Decodable {
    let number: Int
    let name: String
    let startTime: String
    let endTime: String
    let isDaytime: Bool
    let temperature: Int
    let temperatureUnit: String
    let temperatureTrend: String?
    let windSpeed: String
    let windDirection: String
    let shortForecast: String
    let detailedForecast: String
    let probabilityOfPrecipitation: WeatherValues
}
