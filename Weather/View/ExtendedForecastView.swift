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
//        LazyHGrid(rows: Array(repeating: .init(.adaptive(minimum: width, maximum: width)), count: 1), spacing: 8) {
        VStack(alignment: .leading, spacing: 0) {
            TitleView(text: "Exteneded Forecast")
            if let extendedForecast = state.extendedForecast?.properties.periods {
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
                                
//                                Spacer()
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
    }
}

#Preview {
    ExtendedForecastView()
}
