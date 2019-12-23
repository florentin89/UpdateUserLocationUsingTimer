//
//  ViewController.swift
//  UpdateUserLocation
//
//  Created by Florentin Lupascu on 23/12/2019.
//  Copyright © 2019 Florentin Lupascu. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var updateLocationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeInterval: Double = 5.00 // update every 5 seconds
        
        updateLocationTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { timer in
            let timeWhenAppStartRunning = Date()
            print("Updated at: \(timeWhenAppStartRunning + timeInterval)")
            self.updateUserLocation()
        }
    }
    
    // Ask the user for location permission and get the current location
    fileprivate func updateUserLocation(){
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("Now you can get the user location.\n")
        }
    }
    
    //MARK: - User location delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let userLocation = locations.last {
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if (error != nil){
                    print("Error in reverseGeocode.")
                }
                if let placemark = placemarks?.last {
                    print("User area: \(placemark.administrativeArea ?? String())")
                    print("User city: \(placemark.locality ?? String())")
                    print("User country: \(placemark.country ?? String())\n")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
