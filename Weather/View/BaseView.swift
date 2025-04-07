//
//  BaseView.swift
//  Weather
//
//  Created by Greg Patrick on 7/2/22.
//

import SwiftUI

struct BaseView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State private var locationManager = LocationManager()
    @State var state = AppState.shared
    
    var body: some View {
        VStack {
            MainView()
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                debugPrint("** App became active **")
                if isLocationNotDetermined {
                    locationManager.requestLocationPermission()
                } else if isLocationAuthorized {
                    locationManager.startLocationUpdates()
                    if let location = locationManager.location {
                        Task {
                            await Api.getPointData(for: location)
                            await Api.getStationData()
                            let _ = await Api.getCurrentWeather()
                            let _ = await Api.getHourlyForecast()
                            let _ = await Api.getExtendedForecast()
                            
                            locationManager.stopLocationUpdates()
                        }
                    }
                }
            case .background:
                debugPrint("** App became inactive **")
                locationManager.stopLocationUpdates()
            case .inactive:
                debugPrint("** App entered background **")
                locationManager.stopLocationUpdates()
            @unknown default:
                break
            }
        }
    }
}

private extension BaseView {
    var isLocationNotDetermined: Bool {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return true
        default:
            return false
        }
    }
    var isLocationAuthorized: Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}

#Preview {
    BaseView()
}
