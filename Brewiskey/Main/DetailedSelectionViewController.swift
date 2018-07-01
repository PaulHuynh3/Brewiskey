//
//  SelectionOneViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-06-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

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
    var orderNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSelectedItem()
        quantityStepper.value = 1.0
        currentValue = quantityStepper.value
        let itemCount = UserDefaults.standard.double(forKey: kUserInfo.kCheckoutOrderQuantity)
        if itemCount > 0 {
            cartItemCounterLabel.text = String(Int(itemCount))
        }
    }
    
    fileprivate func loadSelectedItem() {
        if isSelectionOne {
            if let beer = beer {
                guard let imageUrl = beer.singleBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.singleBottleType
                if let beerSingleBottlePrice = beer.singleBottlePrice {
                    priceLabel.text = String(beerSingleBottlePrice)
                }
            }
            //if let wine = wine etc
        }
        if isSelectionTwo {
            if let beer = beer {
                guard let imageUrl = beer.singleCanImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.singleCanType
                if let beerSingleCanPrice = beer.singleCanPrice {
                    priceLabel.text = String(beerSingleCanPrice)
                }
            }
        }
        if isSelectionThree {
            if let beer = beer {
                guard let imageUrl = beer.sixPackBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.sixPackBottleType
                
                if let sixPackBottlePrice = beer.sixPackBottlePrice {
                    priceLabel.text = String(sixPackBottlePrice)
                }
            }
        }
        if isSelectionFour {
            if let beer = beer {
                guard let imageUrl = beer.sixPackCanImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.sixPackCanType
                if let sixPackCanPrice = beer.sixPackCanPrice {
                    priceLabel.text = String(sixPackCanPrice)
                }
            }
        }

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
        addItemToCheckout()
    }
}

extension DetailedSelectionViewController {
    
    fileprivate func trackCheckoutCount() {
        let title = ""
        let message = "Added to your Cart"
        let actionTitle = "OK"
        let pastItems = UserDefaults.standard.double(forKey: kUserInfo.kCheckoutOrderQuantity)
        let totalItems = pastItems + currentValue
        UserDefaults.standard.set(totalItems, forKey: kUserInfo.kCheckoutOrderQuantity)
        cartItemCounterLabel.text = String(Int(totalItems))
        showAlert(title: title, message: message, actionTitle: actionTitle)
    }
    
    fileprivate func addItemToCheckout() {
        if isSelectionOne {
            if let beer = beer {
                guard let imageUrl = beer.singleBottleImageUrl else {return}
                guard let itemType = beer.singleBottleType else {return}
                guard let itemPrice = beer.singleBottlePrice else {return}
                guard let name = beer.name else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = itemType
                priceLabel.text = String(itemPrice)
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
        if isSelectionTwo {
            if let beer = beer {
                guard let imageUrl = beer.singleCanImageUrl else {return}
                guard let itemType = beer.singleCanType else {return}
                guard let itemPrice = beer.singleCanPrice else {return}
                guard let name = beer.name else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = itemType
                priceLabel.text = String(itemPrice)
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
        if isSelectionThree {
            if let beer = beer {
                guard let imageUrl = beer.sixPackBottleImageUrl else {return}
                guard let itemType = beer.sixPackBottleType else {return}
                guard let itemPrice = beer.sixPackBottlePrice else {return}
                guard let name = beer.name else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = itemType
                priceLabel.text = String(itemPrice)
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
        if isSelectionFour {
            if let beer = beer {
                guard let imageUrl = beer.sixPackCanImageUrl else {return}
                guard let itemType = beer.sixPackCanType else {return}
                guard let itemPrice = beer.sixPackCanPrice else {return}
                guard let name = beer.name else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = itemType
                priceLabel.text = String(itemPrice)
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
    }
    
    fileprivate func updateUserCartOnFirebase(name: String, imageUrl: String, type: String, price: Double, quantity: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userReference = Database.database().reference().child("users").child(uid).child("cart").child("order_\(provideOrderNumber())")
        let values = ["name": name, "imageUrl" : imageUrl, "type" : type, "price": price, "quantity": quantity] as [String: AnyObject]
        
        userReference.updateChildValues(values) { [weak self] (error, databaseRef) in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                if let error = error {
                    strongSelf.showAlert(title: UIAlertConstants.titleError, message: error.localizedDescription, actionTitle: UIAlertConstants.actionOk)
                    return
                }
                strongSelf.trackCheckoutCount()
            }
        }
    }
    
    fileprivate func provideOrderNumber() -> Int {
        orderNumber = UserDefaults.standard.integer(forKey: kUserInfo.kOrderNumber)
        if var orderNumber = orderNumber {
            orderNumber = orderNumber + 1
            UserDefaults.standard.set(orderNumber, forKey: kUserInfo.kOrderNumber)
            return orderNumber
        } else {
            orderNumber = 0
            UserDefaults.standard.set(orderNumber, forKey: kUserInfo.kOrderNumber)
            return orderNumber!
        }
    }
}

extension Notification.Name {
    static let didReceiveData = Notification.Name("didRecieveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedDownload = Notification.Name("completedDownload")
}
