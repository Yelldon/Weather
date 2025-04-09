//
//  SearchCityView.swift
//  Weather
//
//  Created by Greg Patrick on 4/7/25.
//

import SwiftUI
import MapKit
import SwiftData

struct SearchCityView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedLocation: [SavedLocationModel]
    
    @State var state = AppState.shared
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    
    @Binding var openSheet: Bool
    @Binding var preferredColumn: NavigationSplitViewColumn
    
    @FocusState private var searchFieldFocused: Bool
    
    var body: some View {
        VStack {
            TextField("Search for city", text: $searchText)
                .focused($searchFieldFocused)
                .onChange(of: searchText) {
                    search()
                }
                .onAppear {
                    searchFieldFocused = true
                }
            
            List(searchResults, id: \.identifier) { item in
                if let city = item.placemark.locality,
                   let administrativeArea = item.placemark.administrativeArea {
                    Button(action: {
                        if let lat = item.placemark.location?.coordinate.latitude,
                           let lon = item.placemark.location?.coordinate.longitude {
                            let savedLocation = SavedLocationModel(
                                city: city,
                                state: administrativeArea,
                                lat: lat,
                                lon: lon
                            )
                            
                            modelContext.insert(savedLocation)
                            openSheet = false
                            preferredColumn = .detail
                            
                            state.resetCurrentSelection()
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text("\(city), \(administrativeArea)")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding()
    }
}

extension SearchCityView {
    func search() {
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchText
        request.resultTypes = .address
        request.region = MKCoordinateRegion(.world)

        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            
            debugPrint(response?.mapItems)
            searchResults = response?.mapItems ?? []
        }
    }
}

#Preview {
    SearchCityView(
        openSheet: .constant(true),
        preferredColumn: .constant(.detail)
    )
}
