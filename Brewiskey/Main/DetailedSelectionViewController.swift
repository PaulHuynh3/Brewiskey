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
    var wine: Wine?
    var spirit: Spirit?
    
    @IBOutlet weak var alcoholImageView: UIImageView!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    var selectionNumber = Int()
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
        if selectionNumber == 1 {
            showSelectedItem(selection: selectionNumber)
        }
        if selectionNumber == 2 {
            showSelectedItem(selection: selectionNumber)
        }
        if selectionNumber == 3 {
            showSelectedItem(selection: selectionNumber)
        }
        if selectionNumber == 4 {
            showSelectedItem(selection: selectionNumber)
        }
    }
    
    fileprivate func showSelectedItem(selection: Int) {
        if selection == 1 {
            if let beer = beer {
                guard let imageUrl = beer.singleBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.singleBottleType
                if let beerSingleBottlePrice = beer.singleBottlePrice {
                    priceLabel.text = "\(String(beerSingleBottlePrice))$"
                }
            }
            if let wine = wine {
                guard let imageUrl = wine.imageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = wine.type
                if let winePrice = wine.bottlePrice {
                    priceLabel.text = "\(String(winePrice))$"
                }
            }
            if let spirit = spirit {
                guard let imageUrl = spirit.smallBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = spirit.smallBottleType
                if let smallBottlePrice = spirit.smallBottlePrice {
                    priceLabel.text = "\(String(smallBottlePrice))$"
                }
            }
        }
        
        if selection == 2 {
            if let beer = beer {
                guard let imageUrl = beer.singleCanImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.singleCanType
                if let beerSingleCanPrice = beer.singleCanPrice {
                    priceLabel.text = String(beerSingleCanPrice)
                }
            }
            if let spirit = spirit {
                guard let imageUrl = spirit.mediumBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = spirit.mediumBottleType
                if let mediumBottlePrice = spirit.mediumBottlePrice {
                    priceLabel.text = "\(String(mediumBottlePrice))$"
                }
            }
        }
        if selection == 3 {
            if let beer = beer {
                guard let imageUrl = beer.sixPackBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = beer.sixPackBottleType
                
                if let sixPackBottlePrice = beer.sixPackBottlePrice {
                    priceLabel.text = String(sixPackBottlePrice)
                }
            }
            if let spirit = spirit {
                guard let imageUrl = spirit.mediumBottleImageUrl else {return}
                alcoholImageView.loadImagesUsingCacheWithUrlString(urlString: imageUrl)
                itemTypeLabel.text = spirit.largeBottleType
                if let largeBottlePrice = spirit.largeBottlePrice {
                    priceLabel.text = "\(String(largeBottlePrice))$"
                }
            }
        }
        if selection == 4 {
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
        selectionNumber = 0
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
        if selectionNumber == 1 {
            if let beer = beer {
                guard let imageUrl = beer.singleBottleImageUrl else {return}
                guard let itemType = beer.singleBottleType else {return}
                guard let itemPrice = beer.singleBottlePrice else {return}
                guard let name = beer.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
            if let wine = wine {
                guard let imageUrl = wine.imageUrl else {return}
                guard let itemType = wine.type else {return}
                guard let itemPrice = wine.bottlePrice else {return}
                guard let name = wine.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
            if let spirit = spirit {
                guard let imageUrl = spirit.smallBottleImageUrl else {return}
                guard let itemType = spirit.smallBottleType else {return}
                guard let itemPrice = spirit.smallBottlePrice else {return}
                guard let name = spirit.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
        if selectionNumber == 2 {
            if let beer = beer {
                guard let imageUrl = beer.singleCanImageUrl else {return}
                guard let itemType = beer.singleCanType else {return}
                guard let itemPrice = beer.singleCanPrice else {return}
                guard let name = beer.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
            if let spirit = spirit {
                guard let imageUrl = spirit.mediumBottleImageUrl else {return}
                guard let itemType = spirit.mediumBottleType else {return}
                guard let itemPrice = spirit.mediumBottlePrice else {return}
                guard let name = spirit.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
        if selectionNumber == 3 {
            if let beer = beer {
                guard let imageUrl = beer.sixPackBottleImageUrl else {return}
                guard let itemType = beer.sixPackBottleType else {return}
                guard let itemPrice = beer.sixPackBottlePrice else {return}
                guard let name = beer.name else {return}
 
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
            
            if let spirit = spirit {
                guard let imageUrl = spirit.largeBottleImageUrl else {return}
                guard let itemType = spirit.largeBottleType else {return}
                guard let itemPrice = spirit.largeBottlePrice else {return}
                guard let name = spirit.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
        if selectionNumber == 4 {
            if let beer = beer {
                guard let imageUrl = beer.sixPackCanImageUrl else {return}
                guard let itemType = beer.sixPackCanType else {return}
                guard let itemPrice = beer.sixPackCanPrice else {return}
                guard let name = beer.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: itemType, price: itemPrice, quantity: Int(currentValue))
            }
        }
    }
    
    fileprivate func updateUserCartOnFirebase(name: String, imageUrl: String, type: String, price: Double, quantity: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let orderUuid = UUID().uuidString
        let userReference = Database.database().reference().child("users").child(uid).child("cart").child(orderUuid)
        let values = ["name": name, "imageUrl" : imageUrl, "type" : type, "price": price, "quantity": quantity, "orderUuid": orderUuid] as [String: AnyObject]
        
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
