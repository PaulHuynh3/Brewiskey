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
    var snack: Snacks?
    let networkRequest = NetworkRequest()
    let detailedSelectionViewModel: DetailedSelectionViewModel
    
    required init?(coder aDecoder: NSCoder) {
        detailedSelectionViewModel = DetailedSelectionViewModel()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var alcoholImageView: UIImageView!
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    var selectionNumber = Int()
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var cartItemCounterLabel: UILabel!
    @IBOutlet weak var shoppingCartButton: UIButton!
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
                networkRequest.loadImageFromUrl(urlString: beer.singleCan.imageUrl) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = beer.singleBottle.type
                priceLabel.text = "\(String(beer.singleBottle.price))$"
            }
            if let wine = wine {
                guard let imageUrlString = wine.imageUrl else {return}
                networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = wine.type
                if let winePrice = wine.bottlePrice {
                    priceLabel.text = "\(String(winePrice))$"
                }
            }
            if let spirit = spirit {
                guard let imageUrlString = spirit.smallBottleImageUrl else {return}
                networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = spirit.smallBottleType
                if let smallBottlePrice = spirit.smallBottlePrice {
                    priceLabel.text = "\(String(smallBottlePrice))$"
                }
            }
            if let snack = snack {
                guard let imageUrlString = snack.imageUrl else {return}
                networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = snack.type
                if let snackPrice = snack.price {
                    priceLabel.text = "\(String(snackPrice))$"
                }
            }
        }
        
        if selection == 2 {
            if let beer = beer {
                let imageUrlString = beer.singleCan.imageUrl
                networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = beer.singleCan.type
                priceLabel.text = String(beer.singleCan.price)
                
            }
            if let spirit = spirit {
                guard let imageUrlString = spirit.mediumBottleImageUrl else {return}
                networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = spirit.mediumBottleType
                if let mediumBottlePrice = spirit.mediumBottlePrice {
                    priceLabel.text = "\(String(mediumBottlePrice))$"
                }
            }
        }
        if selection == 3 {
            if let beer = beer {
                networkRequest.loadImageFromUrl(urlString: beer.sixPackBottle.imageUrl) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = beer.sixPackBottle.type
                priceLabel.text = String(beer.sixPackBottle.price)
            }
            if let spirit = spirit {
                guard let imageUrlString = spirit.mediumBottleImageUrl else {return}
                networkRequest.loadImageFromUrl(urlString: imageUrlString) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = spirit.largeBottleType
                if let largeBottlePrice = spirit.largeBottlePrice {
                    priceLabel.text = "\(String(largeBottlePrice))$"
                }
            }
        }
        if selection == 4 {
            if let beer = beer {
                networkRequest.loadImageFromUrl(urlString: beer.sixPackCan.imageUrl) { [weak self] (downloadImage: UIImage?, error: String?) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let error = error {
                        print(error)
                        return
                    }
                    strongSelf.alcoholImageView.image = downloadImage
                }
                itemTypeLabel.text = beer.sixPackCan.type
                priceLabel.text = String(beer.sixPackCan.price)
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
        UpdateCartUtils().updateItemsForCart(items: Int(totalItems))
        showAlert(title: title, message: message, actionTitle: actionTitle)
    }
    
    fileprivate func addItemToCheckout() {
        if selectionNumber == 1 {
            if let beer = beer {
                let imageUrl = beer.singleBottle.imageUrl
                let itemType = beer.singleBottle.type
                let itemPrice = beer.singleBottle.price
                let name = beer.name
                
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
            if let snack = snack {
                guard let imageUrl = snack.imageUrl else {return}
                guard let type = snack.type else {return}
                guard let price = snack.price else {return}
                guard let name = snack.name else {return}
                
                updateUserCartOnFirebase(name: name, imageUrl: imageUrl, type: type, price: price, quantity: Int(currentValue))
            }
        }
        if selectionNumber == 2 {
            if let beer = beer {
               let imageUrl = beer.singleCan.imageUrl
               let itemType = beer.singleCan.type
               let itemPrice = beer.singleCan.price
               let name = beer.name
                
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
                 let imageUrl = beer.sixPackBottle.imageUrl
                 let itemType = beer.sixPackBottle.type
                 let itemPrice = beer.sixPackBottle.price
                 let name = beer.name
 
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
                 let imageUrl = beer.sixPackCan.imageUrl
                 let itemType = beer.sixPackCan.type
                 let itemPrice = beer.sixPackCan.price
                 let name = beer.name
                
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
