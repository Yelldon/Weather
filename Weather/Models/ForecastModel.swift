//
//  ForecastModel.swift
//  Weather
//
//  Created by Greg Patrick on 7/4/22.
//

struct ForecastModel: Decodable {
    let properties: ForecastProperties
}

struct ForecastProperties: Decodable {
    let periods: [ForecastPeriodModel]
}
