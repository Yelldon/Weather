//
//  LocationManager.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    var location: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var errorMessage: String?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        debugPrint("** Getting Location Authorization **")
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        debugPrint("** Getting Location **")
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        debugPrint("** Stopped Getting Location **")
        locationManager.stopUpdatingLocation()
    }
    
    // Handle updated locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        location = latestLocation
        
        if let location {
            location.placemark { placemark, error in
                guard let placemark else {
                    return
                }

                AppState.shared.locationState.cityLocation = placemark.locality
            }
        }
    }
    
    // Handle location errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
        debugPrint("** Location error: \(error.localizedDescription) **")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            errorMessage = "Location access denied or restricted"
            stopLocationUpdates()
        case .notDetermined:
            break
        @unknown default:
            errorMessage = "Unknown authorization status"
        }
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
