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
            .navigationBarHidden(true)
            
//            .safeAreaInset(edge: .top) {
//                VStack(spacing: 0) {
//                    HStack {
//                        Spacer()
//                        Group {
//                            Image(systemName: "location.fill")
//                                .font(.caption)
//                            Text(cityName)
//                                .font(.callout)
//                        }
//                        .foregroundStyle(Color.white)
//                        Spacer()
//                    }
//                }
//                .padding(.bottom)
//                .background(
//                    LinearGradient(
//                        colors: [.white.opacity(0.4), .gray.opacity(0.6)],
//                        startPoint: .topLeading, endPoint: .bottomTrailing
//                    )
//                    .overlay(.ultraThinMaterial)
//                )
//                .shadow(radius: 8)
//            }
//            .navigationBarHidden(true)
        }
    }
}

extension MainView {
    var cityName: String {
        state.locationState.cityLocation ?? "---"
    }
    
    var headerView: some View {
        Button {
            preferredColumn = .sidebar
        } label: {
            VStack {
                HStack(spacing: 0) {
                    Image(systemName: "line.3.horizontal")
                        .padding(.trailing)
                        .foregroundStyle(Color.black)
                    if state.currentSavedSelection == nil {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .padding(.trailing, 4)
                            .foregroundStyle(Color.black)
                    }
                    Text(cityName)
                        .font(.footnote)
                        .foregroundStyle(Color.black)
                }
            }
            .padding(8)
            .background(
                LinearGradient(
                    colors: [.white, .gray.opacity(0.4)],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .background(.white)
            .roundedCorners()
        }
    }
}

#Preview {
    MainView(preferredColumn: .constant(.detail))
}
