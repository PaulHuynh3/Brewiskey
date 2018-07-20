//
//  PastOrdersCell.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-31.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit

class PastOrdersCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var alcoholImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    func setPastOrderCell(orderDetails: OrderDetails) {
        if let purchaseDate = orderDetails.purchasedDate, let totalPrice = orderDetails.totalPrice {
            dateLabel.text = purchaseDate
            priceLabel.text = "You paid: $\(totalPrice)"
//            alcoholImage.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
        }
    }
    
}
