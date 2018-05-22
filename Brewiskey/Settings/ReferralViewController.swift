//
//  ReferralViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-29.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class ReferralViewController: UIViewController {
    
    static let DYNAMIC_LINK_DOMAIN = "YOUR_DYNAMIC_LINK_DOMAIN"
    
    var sections = [Section]()
    var dictionary = [Params: UITextField]()
    var longLink: URL?
    var shortLink: URL?
    
    @IBOutlet weak var referralLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureReferralLabel()
     
    }
    
    fileprivate func configureReferralLabel() {
        if let firstName = UserDefaults.standard.string(forKey: kUserInfo.kFirstName) {
            let referalText = "http://invite.brewiskey.com/\(firstName)\(arc4random())"
            referralLabel.text = referalText
        }
    }

    @IBAction func inviteButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func copyButtonTapped(_ sender: Any) {
        
    }
    
    fileprivate func setUpReferralLink() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let link = URL(string: "https://mygame.example.com/?invitedby=\(uid)")
        let referralLink = DynamicLinkComponents(link: link!, domain: "abc123.app.goo.gl")
        
        referralLink.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.BrewiskeyApp.Group")
        referralLink.iOSParameters?.minimumAppVersion = "10"
        referralLink.iOSParameters?.appStoreID = "1387191975"
        
        referralLink.shorten { (shortURL, warnings, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.referralLabel.text = shortURL?.absoluteString
        }
        
    }
    
    
    fileprivate func createDynamiclink() {
        // general link params
//        https://stackoverflow.com/questions/43702442/ios-dynamic-link-builder-explanation
        
 
    }
    
    
    
}
