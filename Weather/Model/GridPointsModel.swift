struct GridPointsModel: Decodable {
    let properties: GridPointProperties
}

struct GridPointProperties: Decodable {
    let relativeLocation: RelativeLocation
    let forecast: String
    let forecastHourly: String
    let radarStation: String
    let observationStations: String
}

struct RelativeLocation: Decodable {
    let properties: LocationProperties
}

struct LocationProperties: Decodable {
    let city: String
    let state: String
}
