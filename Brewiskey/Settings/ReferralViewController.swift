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
    
    
}
