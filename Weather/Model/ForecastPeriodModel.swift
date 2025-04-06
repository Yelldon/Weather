import Foundation

struct ForecastPeriodModel: Decodable {
//    struct ForecastPeriodModel: Identifiable, Decodable {
//    var id: UUID = UUID()
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
    
//    enum CodingKeys: String, CodingKey {
//        case latitude
//        case longitude
//        case additionalInfo
//    }
    
//    private let icon: String
//    
//    var weatherKey: String {
//        let key = generateWeatherKey(icon)
//        
//        return getWeatherKey(key, isDay: isDaytime)
//    }
}
