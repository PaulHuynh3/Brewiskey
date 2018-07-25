//
//  InternetSyncServices.swift
//  Brewiskey
//
//  Created by Paul on 2018-07-24.
//  Copyright © 2018 Paul. All rights reserved.

import UIKit
import Alamofire

class InternetSyncServices {
    
    class var isConnectedToInternet: Bool {
        if let networkReachable = NetworkReachabilityManager()?.isReachable {
            return networkReachable
        } else {
            return false
        }
    }
    
    
    
    
}
