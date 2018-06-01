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

class FirebaseAPI: NSObject {
    //may not need these api calls...
    
    class func fetchDatabaseCurrentUser(uid:String, completion:@escaping (_ user:User) -> Void) {
        
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
                    completion(user)
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
                }
            }
        })
    }
    class func fetchDatabaseUsers(completion:@escaping (_ user: User) -> Void){
        
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
    class func fetchAllBeerBrandAndImages(completion:@escaping (_ beer: Beer) -> Void){
        //put this network call into a for loop statement so it doesnt need to constantly reload the table?
        Database.database().reference().child("beers").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let beer = Beer()
                beer.name = dictionary["name"] as? String
                beer.imageUrl = dictionary["imageUrl"] as? String
                beer.country = dictionary["country"] as? String
                beer.percent = dictionary["alcoholPercent"] as? String
                
                if let singleCan = dictionary["singleCan"] as? NSDictionary{
                beer.singleCanPrice = singleCan["price"] as? Double
                beer.singleCanContent = singleCan["content"] as? Double
                }
                if let singleBottle = dictionary["singleBottle"] as? NSDictionary{
                beer.singleBottlePrice = singleBottle["price"] as? Double
                beer.singleBottleContent = singleBottle["content"] as? Double
                }
                if let sickPackCan = dictionary["sixPackCan"] as? NSDictionary{
                beer.sixPackCanPrice = sickPackCan["price"] as? Double
                }
                if let sixPackBottle = dictionary["sixPackBottle"] as? NSDictionary{
                beer.sixPackBottlePrice = sixPackBottle["price"] as? Double
                }
                completion(beer)
            }
        }, withCancel: nil)
    }
    class func fetchAllSpiritBrandAndImages(completion:@escaping (_ spirit: Spirit) -> Void){
        
        Database.database().reference().child("spirits").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let spirit = Spirit()
                spirit.name = dictionary["name"] as? String
                spirit.imageUrl = dictionary["imageUrl"] as? String
                spirit.percent = dictionary["alcoholPercent"] as? String
                spirit.country = dictionary["country"] as? String
                
                if let largeBottleDict = dictionary["1140Bottle"] as? NSDictionary{
                    spirit.largeBottlePrice = largeBottleDict["price"] as? Double
                    spirit.largeBottleContent = largeBottleDict["content"] as? Double
                }
                if let mediumBottleDict = dictionary["750Bottle"] as? NSDictionary {
                    spirit.mediumBottlePrice = mediumBottleDict["price"] as? Double
                    spirit.mediumBottleContent = mediumBottleDict["content"] as? Double
                }
                if let smallBottleDict = dictionary["375Bottle"] as? NSDictionary{
                    spirit.smallBottlePrice = smallBottleDict["price"] as? Double
                    spirit.smallBottleContent = smallBottleDict["content"] as? Double
                }
                completion(spirit)
            }
        }, withCancel: nil)
    }
    class func fetchAllWineBrandAndImages(completion:@escaping (_ wine: Wine) -> Void){
        
        Database.database().reference().child("wines").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let wine = Wine()
                wine.name = dictionary["name"] as? String
                wine.imageUrl = dictionary["imageUrl"] as? String
                wine.country = dictionary["country"] as? String
                wine.percent = dictionary["alcoholPercent"] as? String
                
                if let mediumBottleDict = dictionary["750Bottle"] as? NSDictionary{
                    wine.bottlePrice = mediumBottleDict["price"] as? Double
                    wine.bottleContent = mediumBottleDict["content"] as? Double
                }
                completion(wine)
            }
        }, withCancel: nil)
    }
    
    class func loadImageFromUrl(url: URL, completion: @escaping (UIImage) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                print(error, #line)
                return
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                completion(downloadedImage)
                }
            }
        })
        task.resume()
    }
    
}
