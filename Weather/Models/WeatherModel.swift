import Foundation

struct WeatherModel: Decodable {
//    var isLoading = true
    let properties: Temperature
}

struct Temperature: Decodable {
    let timestamp: String
    let textDescription: String
    let temperature: WeatherValues
    let heatIndex: WeatherValues
    
//    private let icon: String
    
//    var weatherKey: String {
//        let key = generateWeatherKey(icon)
//
//        return getWeatherKey(key, isDay: true)
//    }
}

struct WeatherValues: Decodable {
    let unitCode: String
    let value: Double
    let qualityControl: String?
}

