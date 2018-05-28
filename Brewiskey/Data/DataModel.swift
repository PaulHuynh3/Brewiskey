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
    //need to set this in firebase...
    var creditCards: [CreditCard]?
    
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

class Spirit: NSObject {
    var name: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
    
    var largeBottlePrice: String?
    var largeBottleContent: String?
    var mediumBottlePrice: String?
    var mediumBottleContent: String?
    var smallBottlePrice: String?
    var smallBottleContent: String?
}

class Wine: NSObject {
    var name: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
    
    var bottlePrice: String?
    var bottleContent: String?
}

class Beer: NSObject {
    var name: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
    
    var singleCanPrice: String?
    var singleCanContent: String?
    
    var singleBottlePrice: String?
    var singleBottleContent: String?
    
    var sixPackCanPrice: String?
    var sixPackBottlePrice: String?
    
}
