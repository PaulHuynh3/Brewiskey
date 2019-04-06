//
//  FirebaseAPI.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CodableFirebase

class FirebaseAPI: NSObject {
    
    class func fetchDatabaseCurrentUser(uid:String, completion: @escaping (_ user:User) -> Void) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                DispatchQueue.main.async {
                let user = User()
                //this gives the unique user id.
                user.id = snapshot.key
                user.firstName = dictionary["first_name"] as? String
                user.lastName = dictionary["last_name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profile_image_url"] as? String
                user.stripeId = dictionary["stripe_Id"] as? String
                    
                //user sets this when they finish registeration by editing their profile.
                user.age = dictionary["age"] as? String
                user.address.unitNumber = dictionary["unit_number"] as? String
                user.address.number = dictionary["street_number"] as? String
                user.address.street = dictionary["street"] as? String
                user.address.city = dictionary["city"] as? String
                user.address.province = dictionary["province"] as? String
                user.address.postalCode = dictionary["postal_code"] as? String
                
                    if let creditCardDict = dictionary["credit_card"] as? [String: AnyObject] {
                        user.creditCard.number = creditCardDict["number"] as? String
                        user.creditCard.expirationDate = creditCardDict["expiration_date"] as? String
                        user.creditCard.cvcNumber = creditCardDict["cvc"] as? String
                        user.creditCard.postalCode = creditCardDict["postal_code"] as? String
                        user.creditCard.nickname = creditCardDict["nick_name"] as? String
                    }
                    
                    completion(user)
                }
            }
        })
    }
    
    //fetch all users
    class func fetchDatabaseUsers(completion:@escaping (_ user: User) -> Void) {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let user = User()
                user.id = snapshot.key
                user.firstName = dictionary["first_name"] as? String
                user.lastName = dictionary["last_name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profile_image_url"] as? String
                
                completion(user)
            }
            
        }, withCancel: nil)
    }
    
    func fetchAllBeerBrandAndImages(success: @escaping (_ beer: Beer) -> Void, failure: @escaping (_ error: String?) -> Void) {
        let beers = "beers"
        Database.database().reference().child(beers).observe(.childAdded, with: { (snapshot) in

            guard let value = snapshot.value else {
                DispatchQueue.main.async {
                    failure("The value \(beers) is not associated with any value in the database")
                }
                return
            }
            
            do {
                let beer = try FirebaseDecoder().decode(Beer.self, from: value)
                DispatchQueue.main.async {
                    success(beer)
                }
            } catch {
                DispatchQueue.main.async {
                    failure("Failed to decode Beer")
                }
            }
        }, withCancel: { (error: Error) in
            DispatchQueue.main.async {
               failure(error.localizedDescription)
            }
        })
    }
    
    func fetchAllSpiritBrandAndImages(completion:@escaping (_ spirit: Spirit) -> Void){
        
        Database.database().reference().child("spirits").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let spirit = Spirit()
                spirit.name = dictionary["name"] as? String
                spirit.percent = dictionary["alcoholPercent"] as? String
                spirit.country = dictionary["country"] as? String
                
                if let largeBottleDict = dictionary["1140Bottle"] as? NSDictionary{
                    spirit.largeBottlePrice = largeBottleDict["price"] as? Double
                    spirit.largeBottleContent = largeBottleDict["content"] as? Int
                    spirit.largeBottleImageUrl = largeBottleDict["imageUrl"] as? String
                    spirit.largeBottleType = largeBottleDict["type"] as? String
                }
                if let mediumBottleDict = dictionary["750Bottle"] as? NSDictionary {
                    spirit.mediumBottlePrice = mediumBottleDict["price"] as? Double
                    spirit.mediumBottleContent = mediumBottleDict["content"] as? Int
                    spirit.mediumBottleImageUrl = mediumBottleDict["imageUrl"] as? String
                    spirit.mediumBottleType = mediumBottleDict["type"] as? String
                }
                if let smallBottleDict = dictionary["375Bottle"] as? NSDictionary{
                    spirit.smallBottlePrice = smallBottleDict["price"] as? Double
                    spirit.smallBottleContent = smallBottleDict["content"] as? Int
                    spirit.smallBottleImageUrl = smallBottleDict["imageUrl"] as? String
                    spirit.smallBottleType = smallBottleDict["type"] as? String
                }
                DispatchQueue.main.async {
                    completion(spirit)
                }
            }
        }, withCancel: nil)
    }
    func fetchAllWineBrandAndImages(completion:@escaping (_ wine: Wine) -> Void){
        
        Database.database().reference().child("wines").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let wine = Wine()
                wine.name = dictionary["name"] as? String
                wine.imageUrl = dictionary["imageUrl"] as? String
                wine.country = dictionary["country"] as? String
                wine.percent = dictionary["alcoholPercent"] as? String
                
                if let mediumBottleDict = dictionary["750Bottle"] as? NSDictionary{
                    wine.bottlePrice = mediumBottleDict["price"] as? Double
                    wine.bottleContent = mediumBottleDict["content"] as? Int
                    wine.type = mediumBottleDict["type"] as? String
                }
                DispatchQueue.main.async {
                    completion(wine)
                }
            }
        }, withCancel: nil)
    }
    
    func fetchSnacksFromDatabase(completion:@escaping (_ snacks: Snacks) -> Void){
        
        Database.database().reference().child("snacks").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let snacks = Snacks()
                snacks.name = dictionary["name"] as? String
                snacks.price = dictionary["price"] as? Double
                snacks.type = dictionary["type"] as? String
                snacks.imageUrl = dictionary["imageUrl"] as? String

                DispatchQueue.main.async {
                    completion(snacks)
                }
            }
        }, withCancel: nil)
    }
    
    func fetchItemsInCart(completion:@escaping (_ checkoutItems: CheckoutItem?, _ error: String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let database = Database.database().reference()
        let user = FirebaseConstants.usersChild
        let cart = "cart"
        
        //it observes the childnode added on top of cart and keeps looping till all the node is examined.
        database.child(user).child(userID).child(cart).observe(.childAdded, with: { (snapshot) in
            if let orderDictionary = snapshot.value as? [String: AnyObject] {
                let checkoutItem = CheckoutItem()
                checkoutItem.imageUrl = orderDictionary["imageUrl"] as? String
                checkoutItem.price = orderDictionary["price"] as? Double
                checkoutItem.quantity = orderDictionary["quantity"] as? Int
                checkoutItem.type = orderDictionary["type"] as? String
                checkoutItem.name = orderDictionary["name"] as? String
                checkoutItem.orderId = orderDictionary["orderUuid"] as? String
                DispatchQueue.main.async {
                    completion(checkoutItem, nil)
                }
            } else {
                let error = "Error fetching items in cart"
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }, withCancel: nil)
    }
    
    func fetchOrderedItems(completion:@escaping (_ orderDetails: OrderDetails?, _ error: String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let database = Database.database().reference()
        let user = FirebaseConstants.usersChild
        let orderHistory = "order_history"
        database.child(user).child(userID).child(orderHistory)
        //it observes the childnode added on top of cart and keeps looping till all the node is examined.
        database.child(user).child(userID).child(orderHistory).observe(.childAdded, with: { (snapshot) in
            
            
            if let orderDictionary = snapshot.value as? [String: AnyObject] {
                let orderDetails = OrderDetails()
                
                orderDetails.totalPrice = orderDictionary["total_price"] as? Double
                orderDetails.purchasedDate = orderDictionary["date"] as? String

                DispatchQueue.main.async {
                    completion(orderDetails, nil)
                }
            } else {
                let error = "Error fetching items in cart"
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }, withCancel: nil)
    }
    
    func deleteCheckoutItems(_ checkoutItems: Array<CheckoutItem>) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        for cartItem in checkoutItems {
            if let orderId = cartItem.orderId{
                Database.database().reference().child("users").child(uid).child("cart").child(orderId).removeValue()
            }
        }
    }

}
