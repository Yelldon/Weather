//
//  CurrentWeatherView.swift
//  Weather
//
//  Created by Greg Patrick on 7/2/22.
//

import SwiftUI
import CoreLocation

struct CurrentWeatherView: View {
    @State var state = AppState.shared
    
    var body: some View {
        ZStack {
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
            .whiteBackground()
            .blur(radius: networkError ? 4 : 0)
            
            networkErrorView
        }
        .roundedCorners(15)
        .padding()
    }
}

// MARK: Properties
private extension CurrentWeatherView {
    var isLoading: Bool {
        state.isWeatherViewLoading
    }
    
    var temp: String {
        if let temp = state.currentWeather?.properties.temperature.value {
            return String(convertCToF(temp))
        } else {
            return "---"
        }
    }
    
    var lastUpdated: String? {
        if let temp = state.currentWeather {
            return time(temp.properties.timestamp)
        }
        
        return nil
    }
    
    var networkError: Bool {
        state.errorState.appError == .invalidURL
    }
}

// MARK: Views
private extension CurrentWeatherView {
    @ViewBuilder var heatIndexView: some View {
        if let temp = state.currentWeather?.properties.heatIndex.value {
            let index = convertCToF(temp)
            Text("Feels like " + String(index))
        }
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
    
    @ViewBuilder var networkErrorView: some View {
        if networkError {
            ZStack {
                Color.white
                    .opacity(0.2)
                
                VStack(spacing: 8) {
                    Text("There was an error getting your location")
                        .foregroundStyle(.red)
                        .font(.body)
                        .bold()
                    
                    Button("Retry") {
                        state.errorState.resetAppErrors()
                        if let currentSavedSelection = state.currentSavedSelection {
                            let location = CLLocation(
                                latitude: currentSavedSelection.lat,
                                longitude: currentSavedSelection.lon
                            )
                            
                            Task {
                                await Api.getLocationUpdate(location: location)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    VStack {
        CurrentWeatherView()
        Spacer()
    }
    .padding()
}
