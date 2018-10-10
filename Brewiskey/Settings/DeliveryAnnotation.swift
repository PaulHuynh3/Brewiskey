//
//  DeliveryAnnotation.swift
//  Brewiskey
//
//  Created by Paul on 2018-10-10.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import MapKit

class DeliveryAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subTitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subTitle
        
        super.init()
    }
    
    var region : MKCoordinateRegion {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        return MKCoordinateRegionMake(coordinate, span)
    }
}
