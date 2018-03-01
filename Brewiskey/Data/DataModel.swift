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
    var username: String?
    var email: String?
    var profileImageUrl: String?
}

class Spirit: NSObject {
    var name: String?
    var price: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
}

class Wine: NSObject {
    var name: String?
    var price: String?
    var percent: String?
    var country: String?
    var imageUrl: String?
    var shortDescription: String?
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