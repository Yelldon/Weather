//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Greg Patrick on 7/2/22.
//

import SwiftUI

struct CurrentWeatherView: View {
    @StateObject var state = AppState.shared
    
    var body: some View {
        VStack {
//            Text(cityState)
            HStack {
                VStack(alignment: .leading) {
                    DisplayTemp(temp: temp)
                        .font(.system(size: 48))
                    if let heatIndex = heatIndex {
                        Text(heatIndex)
                    }
                    Spacer()
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(radius: 16, y: 8)
    }
}

private extension CurrentWeatherView {
//    var cityState: String {
//        debugPrint("This ran")
//        if let properties = state.pointData?.properties.relativeLocation.properties {
//            return "\(properties.city), \(properties.state)"
//        } else {
//            return ""
//        }
//    }
    
    var temp: String {
        if let temp = state.currentWeather?.properties.temperature.value {
            return String(convertCToF(temp))
        } else {
            return ""
        }
    }
    
    var heatIndex: String? {
        if let temp = state.currentWeather?.properties.heatIndex.value {
            let index = convertCToF(temp)
            return "Feels like " + String(index)
        } else {
            return nil
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
//            Spacer()
            CurrentWeatherView()
            Spacer()
        }
//        .background(.blue)
        .padding()
    }
}
