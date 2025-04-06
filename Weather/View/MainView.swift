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
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        CurrentWeatherView()
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
            .safeAreaInset(edge: .top) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Group {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text(cityName)
                                .font(.callout)
                        }
                        .foregroundStyle(Color.white)
                        Spacer()
                    }
                }
                .padding(.bottom)
                .background(
                    LinearGradient(
                        colors: [.white.opacity(0.4), .gray.opacity(0.6)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .overlay(.ultraThinMaterial)
                )
                .shadow(radius: 8)
            }
            .navigationBarHidden(true)
        }
        
    }
}

extension MainView {
    var cityName: String {
        state.locationState.cityLocation ?? "---"
    }
}

#Preview {
    MainView()
}
