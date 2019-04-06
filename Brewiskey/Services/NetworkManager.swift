//
//  InternetSyncServices.swift
//  Brewiskey
//
//  Created by Paul on 2018-07-24.
//  Copyright © 2018 Paul. All rights reserved.

import UIKit
import Reachability

class NetworkManager: NSObject {
    
    var reachability: Reachability!

    //singleton instance
    static let sharedInstance: NetworkManager = {
        return NetworkManager()
    }()
    
    override init() {
        super.init()
        reachability = Reachability()!
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
        do {
            //start network status notifier
            try reachability.startNotifier()
        } catch {
            print("unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
    
}
