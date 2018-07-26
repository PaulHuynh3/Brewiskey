//
//  MainTabBarViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-07-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    let network: NetworkManager = NetworkManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        UserLoginStatus().handleUserState()
        //check if currently unreachable
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        //check with listener when user turns off wifi..
        network.reachability.whenUnreachable = { _ in
            self.showOfflinePage()
        }
    }

    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
        }
    }
}
