//
//  LocationButton.swift
//  Weather
//
//  Created by Greg Patrick on 4/11/25.
//

import SwiftUI
import SwiftData
import SwipeActions

struct LocationButton: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedLocations: [SavedLocationModel]
    
    @State var state = AppState.shared
    
    let location: SavedLocationModel?
    var onDelete: (IndexSet) -> Void
    var action: () -> Void
    
    
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack(alignment: .leading) {
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
                            
                            Text(state.locationState.cityLocationCurrent ?? "")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.white)
                .roundedCorners()
                .addSwipeAction(edge: .trailing) {
                    if let location {
                        HStack(spacing: 0) {
                            Button(
                                role: .destructive,
                                action: {
                                    deleteItems(with: location.id)
                                }
                            ) {
                                Image(systemName: "trash")
                                    .padding()
                                    .background(.red)
                                    .foregroundStyle(Color.white)
                                    .clipShape(
                                        Circle()
                                    )
                            }
                        }
                        .padding(.leading)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

extension LocationButton {
    func deleteItems(with id: UUID) {
        guard let index = savedLocations.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        withAnimation {
            modelContext.delete(savedLocations[index])
        }
    }
}
    

#Preview {
    LocationButton(
        location: nil,
        onDelete: { _ in },
        action: {}
    )
}
