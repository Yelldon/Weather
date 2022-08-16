//
//  ContentView.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var state = AppState.shared
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Group {
                        CurrentWeatherView()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                }
                .background(.blue)
            }
            .safeAreaInset(edge: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack() {
                        Image(systemName: "location.fill")
                        Text(cityState)
//                            .font(.headline.weight(.bold))
                            .font(.headline)
                        Spacer()
//                        Button(action: {}) {
//                            Image(systemName: "wifi")
//                        }
                    }
//                    Text("With safeAreaInset you can create your own custom nav bar.")
//                        .font(.caption)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.white.opacity(0.4), .blue.opacity(0.8)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .overlay(.ultraThinMaterial)
                )
                .shadow(radius: 8)
                
            }
            .navigationBarHidden(true)
//            .tint(.blue)
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    HStack {
//                        Text(cityState)
//                    }
////                    .background(.ultraThinMaterial)
//                }
////                .background(.ultraThinMaterial)
//            }
//            .background(.ultraThinMaterial)
//            .accentColor(.blue)
//            .onAppear {
//                UINavigationBar.appearance().foregroundColor = .blue
//                UINavigationBar.vi
//                UINavigationBar.app
    //            UINavigationB
//                ar.ba
//                let appearance = UINavigationBarAppearance()
//                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//                appearance.backgroundColor = UIColor(Color.blue.opacity(0.2))
//                UINavigationBar.appearance().scrollEdgeAppearance = appearance
//            }
        }
        
    }
}

extension MainView {
    var cityState: String {
        if let properties = state.pointData?.properties.relativeLocation.properties {
            return "\(properties.city), \(properties.state)"
        } else {
            return ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
