//
//  BaseView.swift
//  Weather
//
//  Created by Greg Patrick on 7/2/22.
//

import SwiftUI
import SwiftData
import CoreLocation

struct BaseView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    @Query private var savedLocations: [SavedLocationModel]
    
    @State var state = AppState.shared
    
    @State private var locationManager = LocationManager()
    @State private var preferredColumn = NavigationSplitViewColumn.detail
    @State private var openSearch: Bool = false
    
    var body: some View {
        VStack {
            NavigationSplitView(
                preferredCompactColumn: $preferredColumn
            ) {
                VStack {
                    VStack(alignment: .leading) {
                        VStack {
                            TextField(
                                "",
                                text: Binding.constant(""),
                                prompt: Text("Search for city")
                                    .foregroundStyle(Color.gray)
                            )
                            .textFieldStyle(BaseFieldStyle())
                            .disabled(true)
                            .accessibilityElement()
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            openSearch = true
                        })
                        
                    }
                    .padding()
                    
                    ScrollView {
                        locationButton(location: nil)
                        ForEach(savedLocations) { location in
                            locationButton(location: location)
                        }
                    }
                    .padding(.horizontal)
                }
                .background(.black)
            } detail: {
                MainView(preferredColumn: $preferredColumn)
                    .sheet(isPresented: $openSearch) {
                        SearchCityView(
                            openSearch: $openSearch,
                            preferredColumn: $preferredColumn
                        )
                    }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                debugPrint("** App became active **")
                if isLocationNotDetermined {
                    locationManager.requestLocationPermission()
                } else if isLocationAuthorized {
                    getLocationUpdate()
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
        .onChange(of: state.currentSavedSelection) { _, selection in
            if let location = selection {
                state.locationState.cityLocation = location.city
                state.resetBaseState()
                Task {
                    await Api.getPointData(for: CLLocation(latitude: location.lat, longitude: location.lon))
                    await Api.getStationData()
                    
                    let _ = await Api.getCurrentWeather()
                    let _ = await Api.getHourlyForecast()
                    let _ = await Api.getExtendedForecast()
                }
            }
        }
        .onChange(of: state.menuIsOpen) { _, open in
            if open {
                preferredColumn = .sidebar
            } else {
                preferredColumn = .detail
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
    
    func locationButton(location: SavedLocationModel?) -> some View {
        Button(action: {
            if let location {
                state.currentSavedSelection = location
            } else {
                getLocationUpdate()
            }
            preferredColumn = .detail
        }) {
            VStack(alignment: .leading) {
                HStack {
                    if let location {
                        Image(systemName: "mappin.and.ellipse")
                        VStack(alignment: .leading) {
                            Text(location.city)
                                .font(.body)
                            Text(location.state)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Image(systemName: "location.fill")
                        VStack(alignment: .leading) {
                            Text("Current Location")
                                .font(.body)
                            Text(state.locationState.cityLocation ?? "")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .roundedCorners()
        }
    }
    
    func getLocationUpdate() {
        state.resetBaseState()
        state.resetCurrentSelection()
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
}

#Preview {
    BaseView()
}
