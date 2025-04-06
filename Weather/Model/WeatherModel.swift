import Foundation

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

