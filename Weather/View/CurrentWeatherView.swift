//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Greg Patrick on 7/2/22.
//

import SwiftUI

struct CurrentWeatherView: View {
    @State var state = AppState.shared
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    tempView
                    heatIndexView
                    lastUpdatedView
//                    Text(state.currentTemp?.properties.weatherKey ?? "")
//                    Image(systemName: state.currentTemp?.properties.weatherKey ?? "questionmark.square.dashed")
//                        .resizable()
//                        .frame(width: 42.0, height: 42.0)
                    
                    
                }
                Spacer()
                VStack(alignment: .trailing) {
                    IconView(weather: state.currentWeather?.properties.textDescription)
                        .frame(width: 24, height: 24)
                    descriptionView
                }
                .frame(minWidth: 0, minHeight: 80.0)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.white, .gray.opacity(0.3)],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
            )
            .shadow(radius: 8)
        }
        .padding()
//        VStack {
////            Text(cityState)
//            HStack {
//                VStack(alignment: .leading) {
//                    DisplayTemp(temp: temp)
//                        .font(.system(size: 48))
//                    if let heatIndex = heatIndex {
//                        Text(heatIndex)
//                    }
//                    Spacer()
//                }
//                Spacer()
//            }
//            Spacer()
//        }
//        .padding()
//        .frame(maxWidth: .infinity, minHeight: 120)
//        .background(.white)
//        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
//        .shadow(radius: 16, y: 8)
    }
}

private extension CurrentWeatherView {
    var temp: String {
        if let temp = state.currentWeather?.properties.temperature.value {
            return String(convertCToF(temp))
        } else {
            return "--"
        }
    }
    
    @ViewBuilder var heatIndexView: some View {
        if let temp = state.currentWeather?.properties.heatIndex.value {
            let index = convertCToF(temp)
            Text("Feels like " + String(index))
        }
    }
    
    var lastUpdated: String? {
        if let temp = state.currentWeather {
            return time(temp.properties.timestamp)
        }
        
        return nil
    }
    
    var descriptionView: some View {
        Text(state.currentWeather?.properties.textDescription ?? "")
    }
    
    var tempView: some View {
        DisplayTemp(temp: temp)
            .font(.largeTitle)
            .bold()
    }
    
    var lastUpdatedView: some View {
        Group {
            if let time = lastUpdated {
                Text("Last updated \(time)")
                //                            .redacted(reason: isLoading ? .placeholder : [])
                
            } else {
                Text("Last updated")
                //                            .redacted(reason: isLoading ? .placeholder : [])
            }
        }
        .font(.system(size: 10.0))
        .foregroundColor(.gray)
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
