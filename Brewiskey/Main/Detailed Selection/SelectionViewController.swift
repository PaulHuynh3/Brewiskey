//
//  SelectionOneViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-06-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    var beer: Beer?
    @IBOutlet weak var alcoholImageView: UIImageView!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    var isSelectionOne = false
    var isSelectionTwo = false
    var isSelectionThree = false
    var isSelectionFour = false
    @IBOutlet weak var quantityStepper: UIStepper!
    var oldValue: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBeerScreen()
        quantityStepper.value = 1.0
        oldValue = quantityStepper.value
    }
    
    fileprivate func setupBeerScreen() {
        if isSelectionOne {
            if let beer = beer {
                guard let imageUrl = beer.singleBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.singleBottleType
                priceLabel.text = beer.singleBottlePrice
            }
        }
        if isSelectionTwo {
            if let beer = beer {
                guard let imageUrl = beer.singleCanImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.singleCanType
                priceLabel.text = beer.singleCanPrice
            }
        }
        if isSelectionThree {
            if let beer = beer {
                guard let imageUrl = beer.sixPackBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.sixPackBottleType
                priceLabel.text = beer.sixPackBottlePrice
            }
        }
        if isSelectionFour {
            if let beer = beer {
                guard let imageUrl = beer.sixPackCanImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.sixPackCanType
                priceLabel.text = beer.sixPackCanPrice
            }
        }

    }
    
    fileprivate func setupWineScreen() {
        
    }
    
    fileprivate func setupSpiritScreen() {
        
    }
    
    @IBAction func stepperTapped(_ sender: Any) {
        
        if quantityStepper.value > oldValue {
            oldValue = oldValue + 1
        } else {
            if oldValue == 1 {
                return
            }
            oldValue = oldValue - 1
        }
        itemQuantityLabel.text = String(Int(oldValue))
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        isSelectionOne = false
        isSelectionTwo = false
        isSelectionThree = false
        isSelectionFour = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        
    }
    



}
