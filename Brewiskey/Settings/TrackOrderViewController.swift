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
    var shouldShowReview = false
    let brewiskeyHQCoordinate = CLLocationCoordinate2D(latitude: 43.6594, longitude: -79.3884)
    let brewiskeyOtherCoordinate = CLLocationCoordinate2D(latitude: 43.6779, longitude: -79.3583)
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        checkUserLocationAccess()
        registerAnnotationView()
        addBrewiskeyAnnotations()
        createDirectionToDestintation()
        if shouldShowReview {
            StoreReviewHelper.checkAndAskForReview()
            shouldShowReview = false
        }
    }
    
    fileprivate func createDirectionToDestintation() {
        let destCoordinates = brewiskeyOtherCoordinate
        
        guard let sourceCoordinates = locationManager.location?.coordinate else {
            return
        }
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response: MKDirections.Response?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            let route = response?.routes[0]
            guard let directionRoute = route?.polyline else {return}
            self.mapView.add(directionRoute, level: .aboveRoads)
            
            guard let rect = route?.polyline.boundingMapRect else {return}
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
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
                locationManager.startUpdatingLocation()
//                zoomToCurrentLocation()
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
    
    fileprivate func addBrewiskeyAnnotations() {
        let brewiskeyHeadQuerter = DeliveryAnnotation(coordinate: brewiskeyHQCoordinate, title: "Brewiskey HQ", subTitle: "Relax..We've got you covered")
        let otherBrewiskeyLocatiionAnnotation = DeliveryAnnotation(coordinate: brewiskeyOtherCoordinate, title: "Brewiskey F1", subTitle: "Relax..We've got you covered")
        mapView.addAnnotation(brewiskeyHeadQuerter)
        mapView.addAnnotation(otherBrewiskeyLocatiionAnnotation)
    }
    
    //Mark MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let deliveryAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            
            deliveryAnnotationView.animatesWhenAdded = true
            deliveryAnnotationView.titleVisibility = .adaptive
            deliveryAnnotationView.subtitleVisibility = .adaptive
            
            return deliveryAnnotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //Shows the direction line on the map
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
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
