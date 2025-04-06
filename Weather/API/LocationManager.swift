//
//  LocationManager.swift
//  Weather
//
//  Created by Greg Patrick on 6/29/22.
//

import Foundation
import CoreLocation

//@Observable
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @ObservationIgnored
    private let locationManager = CLLocationManager()
    
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("Retreiving location")
        guard let location = locations.last else { return }
        
        lastLocation = location
        
        if let lastLocation {
            lastLocation.placemark { placemark, error in
                guard let placemark else {
                    return
                }
                
                AppState.shared.locationState.cityLocation = placemark.locality
            }
        }
        
        Task {
            await Api.getPointData()
            await Api.getStationData()
            let _ = await Api.getCurrentWeather()
            let _ = await Api.getHourlyForecast()
            let _ = await Api.getExtendedForecast()
        }
        
        locationManager.stopUpdatingLocation()
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
