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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TitleView(text: "Hourly Forecast")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 8) {
                    if let hourlyForecasts = state.hourlyForecast?.properties.periods {
                        ForEach(Array(hourlyForecasts.prefix(24).enumerated()), id: \.offset) { index, forecast in
//                            if index != 0 {
                            HStack {
                                VStack(spacing: 4) {
                                    timeView(forecast.startTime)
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color.gray.opacity(0.3))
                                    HStack {
                                        DisplayTemp(temp: String(forecast.temperature))
//                                        Spacer()
                                        IconView(weather: forecast.shortForecast)
                                            .frame(width: 12, height: 12)
                                    }
                                    Text(forecast.shortForecast)
                                        .font(.caption)
                                    Spacer()
                                    chanceOfPrecipView(forecast.probabilityOfPrecipitation.value)
                                    
                                }
                                .padding(2)
                                .padding(.top, 4)
                                .frame(
                                    maxHeight: .infinity
                                )
                                
//                                Spacer()
                            }
                            .frame(width: 80)
                            .padding(4)
//                            .background(.white)
                            .background(
                                LinearGradient(
                                    colors: [.white, .gray.opacity(0.4)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .background(.white)
                            .cornerRadius(8)
                            .shadow(radius: 8)
                            

                                //                                Image(systemName: forecast.weatherKey)
                                //                                    .resizable()
                                //                                    .scaledToFill()
                                //                                    .frame(width: 18, height: 18)
                                //                                Text(forecast.shortForecast)
                                //                                    .font(.system(size: 12.0))
                                //                                    .padding(.bottom, 1)
                                //                                DisplayTemp(temp: String(forecast.temperature), size: 14.0, isLoading: false)
                                //                            }
                                //                            .padding(8)
                                //                            .shadow(radius: 5)
                                
//                            }
                            
                        }
                    }
                }
                .padding()
            }
        }
    }
}

    
extension HourlyForecastView {
    @ViewBuilder func timeView(_ time: String) -> some View {
        if let hour = hour(time) {
            Text(String(hour))
                .font(.caption)
                .padding(.bottom, 1)
        }
    }
    
    @ViewBuilder func chanceOfPrecipView(_ chance: Double?) -> some View {
        if let chance, !chance.isZero {
            HStack(spacing: 0) {
                Image(systemName: "drop.fill")
//                    .resizable()
//                    .scaledToFill()
                    .font(.footnote)
                    .foregroundStyle(Color.blue)
                Text("\(String(format: "%.0f", chance))%")
                    .font(.footnote)
                Spacer()
            }
        }
    }
}

#Preview {
    HourlyForecastView()
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        HourlyForecastView()
//    }
//}
