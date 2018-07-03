//
//  AppDelegate.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        StoreReviewHelper.incrementAppOpenedCount()
        StoreReviewHelper.shouldAllowPromptInAppReview()
        
        if UserDefaults.standard.bool(forKey: kUserInfo.kLoginStatus) {
            transitionToMarketPlace()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled = false
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url,sourceApplication:sourceApplication , annotation: annotation)
        
        return handled
    }
    
    func transitionToMarketPlace(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = mainStoryboard.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
        UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
            self.window?.rootViewController = tabController}, completion: nil)
        }

    func transitionToLogin(){
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let navController = loginStoryboard.instantiateViewController(withIdentifier: "IntroScreen")
        UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
        self.window?.rootViewController = navController
        }, completion: nil)
        
    }
}
extension AppDelegate {
    
    //Firebase Dynamic links.
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        guard let dynamicLinks = DynamicLinks.dynamicLinks() else {
            return false
        }
        
        guard let incomingURL = userActivity.webpageURL else {
            return false
        }
        
        let handled = dynamicLinks.handleUniversalLink(incomingURL) { (dynamiclink, error) in
            if let url = dynamiclink?.url {
                self.handleDeepLink(url: url)
            }
        }
        return handled
    }
    
    func handleDeepLink(url: URL){
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
        let invitedBy = queryItems?.filter({(item) in item.name == "invitedby"}).first?.value
        let user = Auth.auth().currentUser
        // If the user isn't signed in and the app was opened via an invitation
        // link, sign in the user anonymously and record the referrer UID in the
        // user's RTDB record.
        if user == nil && invitedBy != nil {
           
            Auth.auth().signInAnonymously() { (user, error) in
                if let user = user {
                    let userRecord = Database.database().reference().child("users").child(user.uid)
                    UserDefaults.standard.set(invitedBy, forKey: kUserInfo.kReferredBy)
                    userRecord.child("referred_by").setValue(invitedBy)
                    UserDefaults.standard.set("BrewFriend10", forKey: kUserInfo.kBrewFriendReferral10)
                }
            }
        }

    }

}

