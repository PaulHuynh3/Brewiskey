//
//  SelectionOneViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-06-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class DetailedSelectionViewController: UIViewController {
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
    @IBOutlet weak var cartItemCounterLabel: UILabel!
    var currentValue: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBeerScreen()
        quantityStepper.value = 1.0
        currentValue = quantityStepper.value
        let itemCount = UserDefaults.standard.double(forKey: kUserInfo.kCheckoutOrderQuantity)
        if itemCount > 0 {
            cartItemCounterLabel.text = String(Int(itemCount))
        }
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
    
}

extension DetailedSelectionViewController {
    //Actions
    @IBAction func stepperTapped(_ sender: Any) {
        
        if quantityStepper.value > currentValue {
            currentValue = currentValue + 1
        } else {
            if currentValue == 1 {
                return
            }
            currentValue = currentValue - 1
        }
        itemQuantityLabel.text = String(Int(currentValue))
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        isSelectionOne = false
        isSelectionTwo = false
        isSelectionThree = false
        isSelectionFour = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        let checkOutIndex = 1
        let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let checkOutTabBarController = loginStoryboard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
        checkOutTabBarController.selectedIndex = checkOutIndex
        present(checkOutTabBarController, animated: true, completion: nil)
    }
    
    @IBAction func addToOrderTapped(_ sender: Any) {
        let title = ""
        let message = "Added to your Cart"
        let actionTitle = "OK"
        
        let pastItems = UserDefaults.standard.double(forKey: kUserInfo.kCheckoutOrderQuantity)
        let totalItems = pastItems + currentValue
        UserDefaults.standard.set(totalItems, forKey: kUserInfo.kCheckoutOrderQuantity)
        cartItemCounterLabel.text = String(Int(totalItems))
        showAlert(title: title, message: message, actionTitle: actionTitle)
    }
    
}
