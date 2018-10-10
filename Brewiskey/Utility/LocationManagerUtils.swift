//
//  LocationManagerUtils.swift
//  Brewiskey
//
//  Created by Paul on 2018-10-10.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManagerUtils: NSObject, CLLocationManagerDelegate {
    //static makes it a class variable (ARC in viewdidload wipes instance variables thus making the location authorization screen disapepar)
    static let locationManager = CLLocationManager()
    
// Singleton of a variable, can also make this entire class a singleton too
//    class var locationManagerSharedInstance: CLLocationManager {
//        let instance = CLLocationManager()
//        return instance
//    }

    
}
