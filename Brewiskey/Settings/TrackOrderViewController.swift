//
//  TrackOrderViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-10-08.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TrackOrderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        
        //when the app is open and in the background
        locationManager.requestAlwaysAuthorization()
        requestLocationAccess()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            showUserCurrentLocation(location: location)
        }
    }
    
    //mkmapviewdelegate
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span.latitudeDelta = 0.2
        mapRegion.span.longitudeDelta = 0.2

        mapView.setRegion(mapRegion, animated: true)
    }
    
    
    fileprivate func requestLocationAccess(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func showUserCurrentLocation(location: CLLocation) {
        let userLocationCoordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.3, 0.3)
        let region = MKCoordinateRegion(center: userLocationCoordinates, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "Please enable location so we can deliver your product", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (openAction) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
