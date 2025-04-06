//
//  LocationState.swift
//  Weather
//
//  Created by Greg Patrick on 4/5/25.
//

import Foundation
import SwiftUI
import CoreLocation

@Observable
class LocationState {
//    var location = LocationManager()
    var cityLocation: String?
}

extension LocationState {
//    func getLocation() {
//        location = LocationManager()
//    }
    
//    var cityLocationString() async throws -> String? {
//        var locality: String?
//        
//        if let location = location.lastLocation {
//            debugPrint("getting location")
//            debugPrint(location)
//            let position = CLLocation(
//                latitude: location.coordinate.latitude,
//                longitude: location.coordinate.longitude
//            )
//            
//            try await CLGeocoder().reverseGeocodeLocation(position) { placemarks, _ in
//                debugPrint(placemarks?.first?.locality)
//                locality = placemarks?.first?.locality
//            }
//        }
//        
//        return locality
//    }
}
