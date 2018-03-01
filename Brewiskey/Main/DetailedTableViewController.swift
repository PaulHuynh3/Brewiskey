//
//  DetailedTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-03-01.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class DetailedTableViewController: UITableViewController {
    var beerMode = false
    var wineMode = false
    var spiritMode = false
    
    var beer: Beer?{
        didSet{
     
        }
    }
    var wine: Wine?
    var spirit: Spirit?
    
    @IBOutlet weak var alcoholImageview: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAndSetUpLabels()
 
    }
    
    func configureAndSetUpLabels(){
        if beerMode == true{
            if let imageUrl = beer?.imageUrl{
                alcoholImageview.loadImagesUsingCacheWithUrlString(urlString:imageUrl)
            }
            priceLabel.text = beer?.singleCanPrice
            contentLabel.text = beer?.singleCanContent
            countryLabel.text = beer?.country
        }
        else if wineMode == true {
            if let imageUrl = wine?.imageUrl{
                alcoholImageview.loadImagesUsingCacheWithUrlString(urlString:imageUrl)
            }
            priceLabel.text = wine?.mediumBottlePrice
            contentLabel.text = wine?.mediumBottleContent
            countryLabel.text = wine?.country
        }
        else if spiritMode == true {
            if let imageUrl = spirit?.imageUrl{
                alcoholImageview.loadImagesUsingCacheWithUrlString(urlString:imageUrl)
            }
            priceLabel.text = spirit?.largeBottlePrice
            contentLabel.text = spirit?.largeBottleContent
            countryLabel.text = spirit?.country
            
        }
        
    }



}
