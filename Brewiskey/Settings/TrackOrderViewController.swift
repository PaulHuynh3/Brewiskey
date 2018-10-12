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

class TrackOrderViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        LocationManagerUtils.locationManager.delegate = self
        checkUserLocationAccess()
        registerAnnotationView()
//        addLocationAndZoomIn()
    }
    
    fileprivate func checkUserLocationAccess() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                showLocationDisabledPopUp()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                locationManager.requestLocation()
                zoomToCurrentLocation()
            }
        } else {
            print("Location services are not enabled")
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
    
    fileprivate func registerAnnotationView() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

    }
    
    fileprivate func zoomToCurrentLocation() {
        if let coordinateLatitude = locationManager.location?.coordinate.latitude, let coordinateLongtitude = locationManager.location?.coordinate.longitude {
            let userCoordinate = CLLocationCoordinate2D(latitude: coordinateLatitude, longitude: coordinateLongtitude)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(userCoordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    fileprivate func addLocationAndZoomIn() {
        let mitCoordinate = CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0942)
        let mitAnnotation = DeliveryAnnotation(coordinate: mitCoordinate, title: "The Harvard school", subTitle: "This is where it should be")
        mapView.addAnnotation(mitAnnotation)
        mapView.setRegion(mitAnnotation.region, animated: true)
    }
    
}

extension TrackOrderViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let deliveryAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            
            deliveryAnnotationView.animatesWhenAdded = true
            deliveryAnnotationView.titleVisibility = .adaptive
            deliveryAnnotationView.subtitleVisibility = .adaptive
            
            return deliveryAnnotationView
        }
        return nil
    }
    
}

extension TrackOrderViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //if location changed capture it here
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    //listens to authorization change.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
        if status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways {
            zoomToCurrentLocation()
        }
    }
}
