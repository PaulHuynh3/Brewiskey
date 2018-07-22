//
//  CreditCardCell.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-14.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class ImageLabelCell: UITableViewCell {
    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var middleLabel: UILabel!
    
    override func layoutSubviews() {
        leftImage.layer.cornerRadius = leftImage.frame.size.width/2
        leftImage.clipsToBounds = true
    }
    

}
