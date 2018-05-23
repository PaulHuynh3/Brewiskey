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
    
    var longLink: URL?
    var shortLink: URL?
    
    @IBOutlet weak var referralLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupReferralLabel()
    }
    
    fileprivate func setupReferralLabel() {
        let shortLink = UserDefaults.standard.url(forKey: kUserInfo.kReferralLink)
        referralLabel.text = shortLink?.absoluteString
    }

    @IBAction func inviteButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func copyButtonTapped(_ sender: Any) {
        
    }
    
}
