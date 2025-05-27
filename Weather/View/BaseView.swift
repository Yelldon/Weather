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
    
    @State private var preferredColumn = NavigationSplitViewColumn.detail
    @State private var openSearch: Bool = false
    
    var body: some View {
        VStack {
            NavigationSplitView(
                preferredCompactColumn: $preferredColumn
            ) {
                locationMenuView
            } detail: {
                MainView(preferredColumn: $preferredColumn)
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                debugPrint("** App became active **")
                if isLocationNotDetermined {
                    state.locationManager.requestLocationPermission()
                } else if isLocationAuthorized {
                    state.locationManager.startLocationUpdates()
                }
            case .background:
                debugPrint("** App became inactive **")
                state.locationManager.stopLocationUpdates()
            case .inactive:
                debugPrint("** App entered background **")
                state.locationManager.stopLocationUpdates()
            @unknown default:
                break
            }
        }
        .onChange(of: state.locationManager.beginGettingLocation) { _, value in
            if value {
                Task {
                    try await WeatherAPI.shared.getLocationUpdate(location: state.locationManager.location)
                }
                state.locationManager.beginGettingLocation = false
            }
        }
        .onChange(of: state.currentSavedSelection) { _, selection in
            if let location = selection {
                state.locationState.cityLocation = location.city
                state.resetBaseState()
                state.errorState.resetAppErrors()
                Task {
                    try await WeatherAPI.shared.getLocationUpdate(
                        location: CLLocation(latitude: location.lat, longitude: location.lon)
                    )
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

// MARK: Properties
extension BaseView {
    var isLocationNotDetermined: Bool {
        switch state.locationManager.authorizationStatus {
        case .notDetermined:
            return true
        default:
            return false
        }
    }
    var isLocationAuthorized: Bool {
        switch state.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}

// MARK: Views
extension BaseView {
    var locationMenuView: some View {
        VStack {
            VStack {
                VStack {
                    SearchField(text: Binding.constant(""))
                        .disabled(true)
                        .accessibilityElement()
                }
                .simultaneousGesture(TapGesture().onEnded {
                    openSearch = true
                })
                .sheet(isPresented: $openSearch) {
                    SearchCityView(
                        openSearch: $openSearch,
                        preferredColumn: $preferredColumn
                    )
                }
            }
            .padding()
            
            ScrollView {
                VStack {
                    locationButton(location: nil)
                    
                    ForEach(savedLocations) { location in
                        locationButton(location: location)
                    }
                }
                .padding(.horizontal)
                .animation(.easeOut, value: savedLocations)
            }
            
            .foregroundStyle(Color.black)
        }
        .background(
            LinearGradient(
                colors: [.baseDarkGradientStart, .baseDarkGradientEnd],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .containerBackground(.baseDarkGradientStart, for: .navigationSplitView)
        .accessibilityIdentifier("locationMenuButton")
    }
    
    func locationButton(location: SavedLocationModel?) -> some View {
        LocationButton(
            location: location,
            onDelete: { id in
                remove(at: id)
            }
        ) {
            if let location {
                state.currentSavedSelection = location
            } else {
                getLocationUpdate(location: state.locationManager.location)
            }
            
            preferredColumn = .detail
        }
    }
}

// MARK: Functions
extension BaseView {
    func remove(at id: UUID) {
        guard let index = savedLocations.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        withAnimation {
            modelContext.delete(savedLocations[index])
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(savedLocations[index])
            }
        }
    }
    
    func getLocationUpdate(location: CLLocation?) {
        state.resetBaseState()
        state.resetCurrentSelection()
        state.errorState.resetAppErrors()
        Task {
            try await WeatherAPI.shared.getLocationUpdate(location: location)
        }
    }
}

#Preview {
    BaseView()
}
