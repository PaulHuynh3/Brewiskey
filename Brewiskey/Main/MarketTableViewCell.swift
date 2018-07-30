//
//  MarketTableViewCell.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-24.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MarketTableViewCell: UITableViewCell {

    @IBOutlet weak var alcoholImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    
    func setupBeerNamesAndImages(_ beer: Beer){
        
        if let imageUrl = beer.singleBottleImageUrl{
          alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
        }
        brandNameLabel.text = beer.name
    }
    
    func setupSpiritNamesAndImages(_ spirit: Spirit){
        
        if let imageUrl = spirit.mediumBottleImageUrl{
            alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
        }
        brandNameLabel.text = spirit.name
    }
    
    func setupWineNamesAndImages(_ wine: Wine){
        
        if let imageUrl = wine.imageUrl{
            alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
        }
        brandNameLabel.text = wine.name
    }
    
    func setupSnackNamesAndImages(_ snack: Snacks){
        
        if let imageUrl = snack.imageUrl{
            alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
        }
        brandNameLabel.text = snack.name
    }
    
}
