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
    var stripeId: String?
    var address = Address()
    override init() {
        //iniatilize the array before it can be used.
        alcoholItems = NSMutableArray()
    }
    var creditCard = CreditCard()
}

class StripeCustomer {
    var customerId: String?
    var delinquent: Bool?
    var email: String?
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
//look this over.
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
    var shortDescription: String?
    
    var largeBottlePrice: Double?
    var largeBottleContent: Int?
    var largeBottleImageUrl: String?
    var largeBottleType: String?
    
    var mediumBottlePrice: Double?
    var mediumBottleContent: Int?
    var mediumBottleImageUrl: String?
    var mediumBottleType: String?
    
    var smallBottlePrice: Double?
    var smallBottleContent: Int?
    var smallBottleImageUrl: String?
    var smallBottleType: String?
}

class Wine {
    var name: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
    var bottlePrice: Double?
    var bottleContent: Int?
    var type: String?
}

class Beer {
    var name: String?
    var percent: String?
    var country: String?
    var shortDescription: String?
    
    var singleCanPrice: Double?
    var singleCanContent: Int?
    var singleCanImageUrl: String?
    var singleCanType: String?
    
    var singleBottlePrice: Double?
    var singleBottleContent: Int?
    var singleBottleImageUrl: String?
    var singleBottleType: String?
    
    var sixPackCanPrice: Double?
    var sixPackCanImageUrl: String?
    var sixPackCanType: String?
    
    var sixPackBottlePrice: Double?
    var sixPackBottleImageUrl: String?
    var sixPackBottleType: String?
}

class CheckoutItem {
    var name: String?
    var imageUrl: String?
    var price: Double?
    var quantity: Int?
    var type: String?
    var orderId: String?
}
