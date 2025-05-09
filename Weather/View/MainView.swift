//
//  ContentView.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import SwiftUI
import CoreLocation

struct MainView: View {
    @State var state = AppState.shared
    
    @Binding var preferredColumn: NavigationSplitViewColumn
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        headerView
                        CurrentWeatherView()
                            .accessibilityIdentifier("currentWeatherView")
                        HourlyForecastView()
                        ExtendedForecastView()
                    }
                    .padding(.top, 2)
                }
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


// MARK: Properties
extension MainView {
    var isLoading: Bool {
        state.isWeatherViewLoading
    }
    
    var cityName: String {
        let defaultString = "---"
        
        if state.currentSavedSelection == nil {
            return state.locationState.cityLocationCurrent ?? defaultString
        }
        
        return state.locationState.cityLocation ?? defaultString
    }
}

// MARK: Views
extension MainView {
    @ViewBuilder var headerView: some View {
        if Config.shared.isPhone {
            Button {
                preferredColumn = .sidebar
            } label: {
                cityView
            }
            .accessibilityIdentifier("locationMenuView")
            .padding()
        } else {
            cityView
        }
    }
    
    var cityView: some View {
        VStack {
            HStack(spacing: 0) {
                if Config.shared.isPhone {
                    Image(systemName: "line.3.horizontal")
                        .padding(.trailing)
                        .foregroundStyle(Color.black)
                }

                if state.currentSavedSelection == nil {
                    Image(systemName: "location.fill")
                        .font(.caption)
                        .padding(.trailing, 4)
                        .foregroundStyle(Color.black)
                }
                
                Text(cityName)
                    .font(.footnote)
                    .foregroundStyle(Color.black)
                    .contentLoading(isLoading)
            }
        }
        .padding(8)
        .whiteBackground()
        .roundedCorners()
    }
}

#Preview {
    MainView(preferredColumn: .constant(.detail))
}
