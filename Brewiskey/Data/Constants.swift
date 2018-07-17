//
//  Constants.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-06.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import Firebase

struct kUserInfo {
    static let kFirstName = "firstName"
    static let kLastName = "lastName"
    static let kUserId = "userId"
    static let kLoginStatus = "loginStatus"
    static let kNewUser = "newUser"
    static let kEmail = "email"
    static let kReferralLink = "referralLink"
    static let kReferredBy = "referredBy"
    static let isUsedReferralCode = "isUsedReferralCode"
    static let kBrewFriendReferral10 = "brewFriendReferral10"
    static let kCheckoutOrderQuantity = "kCheckoutOrderQuantity"
    static let kOrderNumber = "kOrderNumber"
    static let kAppOpenedCount = "kAppOpenedCount"
    static let kShouldAskForReview = "kShouldAskForReview"
    static let kStripeId = "kStripeId"
}

struct Storyboard {
    static let Login = "Login"
    static let Main = "Main"
}

struct UIAlertConstants {
    static let titleError = "Error"
    static let actionOk = "OK"
}

struct FirebaseConstants {
    static let database = Database.database().reference()
    static let currentUserID = Auth.auth().currentUser?.uid
    static let usersChild = "users"
    static let wineChild = "wine"
    static let spiritsChild = "spirits"
    static let beersChild = "beers"
}
