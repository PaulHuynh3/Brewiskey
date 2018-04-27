//
//  ShoppingCartContainerViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-05.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class ShoppingCartContainerViewController: UIViewController {
    //make a reference to vc to use its variables..
    var alcoholSelectionTableView: AlcoholSelectionTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func addToCartTapped(_ sender: Any) {
        if self.navigationController is MarketNavController {
            let marketNav = self.navigationController as! MarketNavController
            let user = marketNav.user
            
            user?.alcoholItems?.addObjects(from: [alcoholSelectionTableView?.selectedItem as Any])
            let alert = UIAlertController(title: "", message: "Saved to shopping cart", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        print("Proceed to checkout.")
        
    }
    
    
    

}
