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
    
    @Binding var openSearch: Bool
    @Binding var preferredColumn: NavigationSplitViewColumn
    
    @FocusState private var searchFieldFocused: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    SearchField(text: $searchText)
                        .focused($searchFieldFocused)
                        .onAppear {
                            searchFieldFocused = true
                        }
                        .onChange(of: searchText) {
                            search()
                        }
                        .onChange(of: searchFieldFocused) { _, focused in
                            openSearch = focused
                            if !openSearch {
                                searchText = ""
                                searchResults = []
                            }
                        }
                    
                    VStack {
                        Button("Cancel") {
                            searchFieldFocused = false
                        }
                    }
                    .animation(.easeInOut, value: searchFieldFocused)
                }
                .padding()
                
                VStack {
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
                                    openSearch = false
                                    preferredColumn = .detail
                                    state.resetCurrentSelection()
                                }
                            }) {
                                VStack(alignment: .leading) {
                                    Text("\(city), \(administrativeArea)")
                                        .foregroundStyle(Color.white)
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .background(.dark)
    }
}

extension SearchCityView {
    func search() {
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchText
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(.world)

        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            
            searchResults = response?.mapItems ?? []
        }
    }
}

#Preview {
    SearchCityView(
        openSearch: .constant(true),
        preferredColumn: .constant(.detail)
    )
}
