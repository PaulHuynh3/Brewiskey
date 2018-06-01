//
//  PastOrdersTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-31.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class PastOrdersTableViewController: UITableViewController {
    
    fileprivate var alcohols = [purchasedAlcohols]()
    fileprivate let customCellIdentifier = "PastOrdersCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibTableView(cellIdentifier: customCellIdentifier)
    }
    
    fileprivate func setupNibTableView(cellIdentifier: String) {
        let nibName = "PastOrdersCell"
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    fileprivate func totalBeerPrice(indexPath: IndexPath) -> Double {
        var totalBeerPrice = 0.00
        
        if let singleCanPrice = alcohols[indexPath.row].beer.singleCanPrice {
            totalBeerPrice = singleCanPrice
        }
        if let singleBottlePrice = alcohols[indexPath.row].beer.singleBottlePrice {
            totalBeerPrice = totalBeerPrice + singleBottlePrice
        }
        if let sixCanPrice = alcohols[indexPath.row].beer.sixPackCanPrice {
            totalBeerPrice = totalBeerPrice + sixCanPrice
        }
        if let sixBottlePrice = alcohols[indexPath.row].beer.sixPackBottlePrice {
            totalBeerPrice = totalBeerPrice + sixBottlePrice
        }
        return totalBeerPrice
    }
    
    fileprivate func totalSpiritPrice(indexPath: IndexPath) -> Double {
        var totalSpiritPrice = 0.00
        
        if let smallSpiritPrice = alcohols[indexPath.row].spirit.smallBottlePrice {
            totalSpiritPrice = smallSpiritPrice
        }
        if let mediumSpiritPrice = alcohols[indexPath.row].spirit.mediumBottlePrice {
            totalSpiritPrice = totalSpiritPrice + mediumSpiritPrice
        }
        if let largeSpiritPrice = alcohols[indexPath.row].spirit.largeBottlePrice {
            totalSpiritPrice = totalSpiritPrice + largeSpiritPrice
        }
        
        return totalSpiritPrice
    }
    
    fileprivate func totalWinePrice(indexPath: IndexPath) -> Double {
        var totalWinePrice = 0.00
        
        if let winePrice = alcohols[indexPath.row].wine.bottlePrice {
            totalWinePrice = winePrice
        }
        
        return totalWinePrice
    }

}

extension PastOrdersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return alcohols.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellIdentifier, for: indexPath) as! PastOrdersCell
        
        let purchasedDate = alcohols[indexPath.row].purchasedDate
        
        let totalAlcoholPrice = totalBeerPrice(indexPath: indexPath) + totalSpiritPrice(indexPath: indexPath) + totalWinePrice(indexPath: indexPath)
        
        let image = #imageLiteral(resourceName: "partyHard")
        
        cell.alcoholImage.image = image
        cell.dateLabel.text = purchasedDate
        cell.priceLabel.text = "$\(totalAlcoholPrice)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 100
        
        return height
    }
    
}
