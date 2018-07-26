//
//  StoreReviewHelper.swift
//  Brewiskey
//
//  Created by Paul on 2018-07-02.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import StoreKit

struct StoreReviewHelper {
    
    //For existing users of the app.
    static func shouldAllowPromptInAppReview() {
        if UserDefaults.standard.integer(forKey: kUserInfo.kAppOpenedCount) < 2 {
            UserDefaults.standard.set(true, forKey: kUserInfo.kShouldAskForReview)
        }
    }
    
    static func incrementAppOpenedCount() {
        guard var appOpenCount = UserDefaults.standard.value(forKey: kUserInfo.kAppOpenedCount) as? Int else {
            UserDefaults.standard.set(1, forKey: kUserInfo.kAppOpenedCount)
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: kUserInfo.kAppOpenedCount)
    }
    
    static func checkAndAskForReview() {
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        
        guard let appOpenCount = UserDefaults.standard.value(forKey: kUserInfo.kAppOpenedCount) as? Int else {
            UserDefaults.standard.set(1, forKey: kUserInfo.kAppOpenedCount)
            return
        }
        if UserDefaults.standard.bool(forKey: kUserInfo.kShouldAskForReview) && appOpenCount > 0 {
            //ask user one time for review
            UserDefaults.standard.set(false, forKey: kUserInfo.kShouldAskForReview)
            StoreReviewHelper().requestReview()
        }
    }
    
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }
}
