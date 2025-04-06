//
//  BaseView.swift
//  Weather
//
//  Created by Greg Patrick on 7/2/22.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var locationManager = LocationManager()
    
    @State var state = AppState.shared
    
    var body: some View {
//        TabView {
            VStack {
                MainView()
            }
//        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                debugPrint("** App became active **")
//                locationManager = LocationManager()
//                state.location = LocationManager()
//                state.locationState.getLocation()
            case .background:
                debugPrint("** App became inactive **")
            case .inactive:
                debugPrint("** App entered background **")
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    BaseView()
}
