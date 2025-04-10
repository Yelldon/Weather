//
//  SwiftUIView.swift
//  
//
//  Created by Greg Patrick on 5/3/22.
//

import SwiftUI
import Foundation

struct HourlyForecastView: View {
    @State var state = AppState.shared
    
    @State var width: CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            if let hourlyForecasts {
                TitleView(text: "Hourly Forecast")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(Array(hourlyForecasts.prefix(24).enumerated()), id: \.offset) { index, forecast in
                            HStack {
                                VStack(spacing: 4) {
                                    timeView(forecast.startTime)
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color.gray.opacity(0.3))
                                    HStack {
                                        DisplayTempView(temp: String(forecast.temperature))
                                        IconView(weather: forecast.shortForecast)
                                            .frame(width: 12, height: 12)
                                    }
                                    Text(forecast.shortForecast)
                                        .font(.footnote)
                                    Spacer()
                                    chanceOfPrecipView(
                                        forecast.probabilityOfPrecipitation.value
                                    )
                                }
                                .padding(2)
                                .padding(.top, 4)
                                .frame(
                                    maxHeight: .infinity
                                )
                            }
                            .frame(width: width)
                            .padding(4)
                            .whiteBackground()
                            .roundedCorners()
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            width = UIScreen.main.bounds.width / 6
        }
        .animation(.easeInOut, value: isLoading)
    }
}

    
extension HourlyForecastView {
    var hourlyForecasts: [ForecastPeriodModel]? {
        state.hourlyForecast?.properties.periods
    }
    
    var isLoading: Bool {
        guard let hourlyForecasts else {
            return true
        }
        
        return hourlyForecasts.isEmpty
    }
}

extension HourlyForecastView {
    @ViewBuilder func timeView(_ time: String) -> some View {
        if let hour = hour(time) {
            Text(String(hour))
                .font(.caption)
        }
    }
    
    @ViewBuilder func chanceOfPrecipView(_ chance: Double?) -> some View {
        if let chance, !chance.isZero {
            HStack(spacing: 0) {
                Image(systemName: "drop.fill")
                    .font(.footnote)
                    .foregroundStyle(Color.blue)
                Text("\(String(format: "%.0f", chance))%")
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    HourlyForecastView()
}
