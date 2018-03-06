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
    
    
    class func fetchDatabaseCurrentUser(uid:String, completion:@escaping (_ user:User) -> Void){
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let user = User()
                //this gives the unique user id.
                user.id = snapshot.key
                user.username = dictionary["username"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
                
                completion(user)
            }
        })
    }
    class func fetchDatabaseUsers(completion:@escaping (_ user: User) -> Void){
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let user = User()
                user.id = snapshot.key
                user.username = dictionary["username"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                
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
                beer.singleCanPrice = singleCan["price"] as? String
                beer.singleCanContent = singleCan["content"] as? String
                }
                if let singleBottle = dictionary["singleBottle"] as? NSDictionary{
                beer.singleBottlePrice = singleBottle["price"] as? String
                beer.singleBottleContent = singleBottle["content"] as? String
                }
                if let sickPackCan = dictionary["sixPackCan"] as? NSDictionary{
                beer.sixPackCanPrice = sickPackCan["price"] as? String
                }
                if let sixPackBottle = dictionary["sixPackBottle"] as? NSDictionary{
                beer.sixPackBottlePrice = sixPackBottle["price"] as? String
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
                    spirit.largeBottlePrice = largeBottleDict["price"] as? String
                    spirit.largeBottleContent = largeBottleDict["content"] as? String
                }
                if let mediumBottleDict = dictionary["750Bottle"] as? NSDictionary {
                    spirit.mediumBottlePrice = mediumBottleDict["price"] as? String
                    spirit.mediumBottleContent = mediumBottleDict["content"] as? String
                }
                if let smallBottleDict = dictionary["375Bottle"] as? NSDictionary{
                    spirit.smallBottlePrice = smallBottleDict["price"] as? String
                    spirit.smallBottleContent = smallBottleDict["content"] as? String
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
                    wine.bottlePrice = mediumBottleDict["price"] as? String
                    wine.bottleContent = mediumBottleDict["content"] as? String
                }
                completion(wine)
            }
        }, withCancel: nil)
    }
    
    
}

