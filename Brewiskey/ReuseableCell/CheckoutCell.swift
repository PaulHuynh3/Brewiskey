//
//  checkoutCell.swift
//  Brewiskey
//
//  Created by Paul on 2018-06-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class CheckoutCell: UITableViewCell {
 
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var nameTypeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    var item: CheckoutItem?
    
    func setCheckoutCell() {
        
        if let quantity = item?.quantity {
            quantityLabel.text = "\(String(quantity))x"
        }
        if let name = item?.name, let type = item?.type {
            nameTypeLabel.text = "\(name) - \(type)"
        }
        if let price = item?.price, let quantity = item?.quantity {
            
            let perItemTotalCost = price * Double(quantity)
                costLabel.text = "\(String(perItemTotalCost))$"
        }
    }
}
