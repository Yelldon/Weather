//
//  SwiftUIView.swift
//  
//
//  Created by Greg Patrick on 5/3/22.
//

import SwiftUI

struct ExtendedForecastView: View {
    @State var state = AppState.shared
    @State var width: CGFloat = .zero
    @State var height: CGFloat = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let extendedForecast {
                TitleView(text: "Exteneded Forecast")
                
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(extendedForecast, id: \.number) { forecast in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(forecast.name)
                                        .font(.callout)
                                        .bold()
                                    
                                    Text(forecast.detailedForecast)
                                        .font(.caption)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.white)
                            .frame(
                                minWidth: width,
                                maxWidth: width,
                                minHeight: height,
                                maxHeight: height
                            )
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.black.opacity(0.4), .black.opacity(0.9)],
                                    startPoint: .topTrailing, endPoint: .bottomTrailing
                                )
                                .overlay(.ultraThinMaterial)
                            )
                            .roundedCorners(15)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .accessibilityIdentifier("extendedForecastScrollView")
            }
        }
        .onAppear {
            // This works for iOS well, but will need to be fixed in iPadOS, Mac, etc...
            width = UIScreen.main.bounds.width / 2
            height = UIScreen.main.bounds.height / 4
        }
        .animation(.easeInOut, value: isLoading)
    }
}

// MARK: Properties
extension ExtendedForecastView {
    var extendedForecast: [ForecastPeriod]? {
        state.extendedForecast?.properties.periods
    }
    
    var isLoading: Bool {
        guard let extendedForecast else {
            return true
        }
        
        return extendedForecast.isEmpty
    }
}

#Preview {
    ExtendedForecastView()
}
