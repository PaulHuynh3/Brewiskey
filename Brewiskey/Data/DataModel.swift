//
//  User.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-22.
//  Copyright © 2018 Paul. All rights reserved.
//
import Foundation
import Firebase
import UIKit

class User: NSObject {
    var id: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var profileImageUrl: String?
    var alcoholItems: NSMutableArray?
    var age: String?
    var address = Address()
    override init() {
        //iniatilize the array before it can be used.
        alcoholItems = NSMutableArray()
    }
    var creditCard = CreditCard()
    
}

class CreditCard {
    var number: String?
    var expirationDate: String?
    var cvcNumber: String?
    var postalCode: String?
    var nickname: String?
}

class Address: NSObject {
    var number: String?
    var unitNumber: String?
    var street: String?
    var city: String?
    var province: String?
    var postalCode: String?
}

class purchasedAlcohols {
    var purchasedDate: String?
    var spirit = Spirit()
    var wine = Wine()
    var beer = Beer()
}

class Spirit {
    var name: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
    
    var largeBottlePrice: Double?
    var largeBottleContent: Double?
    var mediumBottlePrice: Double?
    var mediumBottleContent: Double?
    var smallBottlePrice: Double?
    var smallBottleContent: Double?
}

class Wine {
    var name: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
    
    var bottlePrice: Double?
    var bottleContent: Double?
}

class Beer {
    var name: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
    
    var singleCanPrice: Double?
    var singleCanContent: Double?
    var singleCanImageUrl: String?
    
    var singleBottlePrice: Double?
    var singleBottleContent: Double?
    var singleBottleImageUrl: String?
    
    var sixPackCanPrice: Double?
    var sixPackCanImageUrl: String?
    
    var sixPackBottlePrice: Double?
    var sixPackBottleImageUrl: String?
}
