//
//  FirebaseDynamicLinkHelper.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation


import Firebase

enum Params: String {
    //analytics
    case source = "Brewiskey Site"
    case medium = "Sharing"
    case campaign = "Friend Referral"
    case term = "If app is shared"
    case content = "$10 inside."
    //Important
    case link = "http://www.brewiskey.com/10promo/"
    case bundleID = "com.BrewiskeyApp.Group"
    case fallbackURL = "http://www.brewiskey.com"
    case minimumAppVersion = "9.0"
    case iPadBundleID = ""
    case iPadFallbackURL = " "
    case appStoreID = "1387191975"
    case affiliateToken = "Affiliate Token"
    case campaignToken = "Campaign Token"
    case providerToken = "Provider Token"
    case minimumVersion = "9"
    //social params
    case title = "Refer a friend!"
    case descriptionText = "Refer a friend for $10 off"
    case imageURL = "https://www.google.com/doodles/googles-16th-birthday"
    case otherFallbackURL = "https://www.brewiskey.com"
}

class FirebaseDynamicLinkHelper {
    
    static let DYNAMIC_LINK_DOMAIN = "tba7j.app.goo.gl"
    
        func createReferralDynamicLink(completion: @escaping (_ shortLink: URL?, _ error: String?) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            let linkString = "http://www.brewiskey.com/10promo/?invitedby=\(uid)"
            
            if let link = URL(string: linkString) {
                let components = DynamicLinkComponents(link: link, domain: FirebaseDynamicLinkHelper.DYNAMIC_LINK_DOMAIN)
                
                // analytics params
                let analyticsParams = DynamicLinkGoogleAnalyticsParameters(
                    source: Params.source.rawValue, medium: Params.medium.rawValue,
                    campaign: Params.campaign.rawValue)
                analyticsParams.term = Params.term.rawValue
                analyticsParams.content = Params.content.rawValue
                components.analyticsParameters = analyticsParams
                
                let bundleID = Params.bundleID.rawValue
                // iOS params
                let iOSParams = DynamicLinkIOSParameters(bundleID: bundleID)
                iOSParams.minimumAppVersion = Params.minimumAppVersion.rawValue
                iOSParams.appStoreID = Params.appStoreID.rawValue
                components.iOSParameters = iOSParams
                
                components.shorten { (shortURL, warnings, error) in
                    // Handle shortURL.\
                    DispatchQueue.main.async {
                        if let error = error {
                            print(error.localizedDescription)
                            completion(nil, error.localizedDescription)
                            return
                        }
                        completion(shortURL, nil)
                    }
                }
            }
            
        }
    }
    
}
