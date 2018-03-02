//
//  AlcoholSelectionTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-01.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class AlcoholSelectionTableViewController: UITableViewController {
    var beer: Beer?
    var wine: Wine?
    var spirit: Spirit?
    var selectedItem: NSMutableArray!
    
    var beerMode = false
    var wineMode = false
    var spiritMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if beerMode == true{
        print((beer?.name)! + (beer?.country)!)
        }
        if wineMode == true {
        print(wine?.name!)
        }
    }

    
    
}
