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
            
//            if isLoading {
//                loadingView
//            }
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
                            .cornerRadius(15)
                            .shadow(radius: 8)
                        }
                    }
                    .padding()
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                width = proxy.size.width / 2
                                height = proxy.size.height * 4
                            }
                    }
                )
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

extension ExtendedForecastView {
    var extendedForecast: [ForecastPeriodModel]? {
        state.extendedForecast?.properties.periods
    }
    
    var isLoading: Bool {
        guard let extendedForecast else {
            return true
        }
        
        return extendedForecast.isEmpty
    }
    
    var loadingView: some View {
        HStack {
            ForEach(0..<2) { _ in
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Loading Animation")
                            .font(.callout)
                            .bold()
                            .redacted(reason: .placeholder)
                        Text("Loding Animation. This is a bunch of loading text that will never actually load")
                            .font(.caption)
                            .redacted(reason: .placeholder)
                        Spacer()
                    }
                    .padding()
                }
                .background(Color.white.opacity(0.3))
                .frame(
//                            minWidth: width,
//                            maxWidth: width,
                    minHeight: height,
                    maxHeight: height
                )
                .cornerRadius(15)
                .shadow(radius: 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ExtendedForecastView()
}
