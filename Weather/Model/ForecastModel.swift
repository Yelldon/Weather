struct ForecastModel: Decodable {
    let properties: ForecastProperties
}

struct ForecastProperties: Decodable {
    let periods: [ForecastPeriodModel]
}
