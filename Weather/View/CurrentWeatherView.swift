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
                }
                Spacer()
                VStack(alignment: .trailing) {
                    descriptionIconView
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
    }
}

private extension CurrentWeatherView {
    var isLoading: Bool {
        state.isWeatherViewLoading
    }
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
    
    var descriptionIconView: some View {
        IconView(weather: state.currentWeather?.properties.textDescription)
            .frame(width: 24, height: 24)
            .contentLoading(isLoading)
    }
    
    var descriptionView: some View {
        Text(state.currentWeather?.properties.textDescription ?? "-----")
            .contentLoading(isLoading)
    }
    
    var tempView: some View {
        DisplayTempView(temp: temp)
            .font(.largeTitle)
            .bold()
            .contentLoading(isLoading)
    }
    
    var lastUpdatedView: some View {
        Group {
            if let lastUpdated {
                Text("Last updated \(lastUpdated)")
            } else {
                Text("Last updated")
            }
        }
        .font(.system(size: 10.0))
        .foregroundColor(.gray)
        .contentLoading(isLoading)
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
