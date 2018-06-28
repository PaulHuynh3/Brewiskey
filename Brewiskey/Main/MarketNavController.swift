//
//  MarketNavController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-05.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MarketNavController: UINavigationController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User()
    }
}
