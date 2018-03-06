//
//  ShoppingCartContainerViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-05.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class ShoppingCartContainerViewController: UIViewController {
    
    var alcoholSelectionTableView: AlcoholSelectionTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addToCartTapped(_ sender: Any) {
        if self.navigationController is MarketNavController {
            let marketNav = self.navigationController as! MarketNavController
            let user = marketNav.user
            
            user?.alcoholItems?.addObjects(from: [alcoholSelectionTableView?.selectedItem as Any])
            print("Alcohol saved to shopping cart")
        }
        
    }
    
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        print("Proceed to checkout.")
        
    }
    
    
    

}
