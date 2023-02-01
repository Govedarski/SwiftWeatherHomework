//
//  LocationManager.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 23.01.23.
//

import CoreLocation
struct Coordinates{
    var latitude:String
    var longitude:String
}
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var currentLocationName = "Current location"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinates = Coordinates(latitude: String(location.coordinate.latitude),
                                      longitude: String(location.coordinate.longitude))
        
        NotificationCenter.default.post(name: .locationUpdated, object: coordinates)
        self.stopUpdatingLocation()
    }
}
