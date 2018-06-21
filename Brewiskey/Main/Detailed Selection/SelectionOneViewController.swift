//
//  SelectionOneViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-06-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class SelectionOneViewController: UIViewController {
    
    @IBOutlet weak var alcoholImageView: UIImageView!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepperTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        
    }
    



}
