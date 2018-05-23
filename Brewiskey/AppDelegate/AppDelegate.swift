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
        let tabController = mainStoryboard.instantiateViewController(withIdentifier: "MarketPlace") as! UITabBarController
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
    
    //firebase dynamic link
    func application(_ app: UIApplication, open url: URL, options: [String : AnyObject]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink: dynamicLink)
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        if let incomingURL = userActivity?.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks()!.handleUniversalLink(incomingURL) { [weak self] (dynamicLink, error) in
                guard let strongSelf = self else {return}
                if let dynamicLink = dynamicLink, let _ = dynamicLink.url {
                    strongSelf.handleIncomingDynamicLink(dynamicLink: dynamicLink)
                }
            }
            return linkHandled
        }
        return false
    }
    
    func handleIncomingDynamicLink(dynamicLink: DynamicLink) {
        guard let pathComponents = dynamicLink.url?.pathComponents else {return}
        for nextPiece in pathComponents {
            //do some smart parsing here.
        }
        print("Your incoming link parameter is \(dynamicLink.url)")
    }

}

