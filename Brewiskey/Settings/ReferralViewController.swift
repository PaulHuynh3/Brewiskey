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
        setupReferralLabel()
    }
    
    fileprivate func setupReferralLabel() {
        if let shortLink = UserDefaults.standard.url(forKey: kUserInfo.kReferralLink) {
            referralLabel.text = shortLink.absoluteString
        }
    }

    @IBAction func inviteButtonTapped(_ sender: Any) {
        guard let referralLink = referralLabel.text else{return}
        let message = "Join Brewiskey and receive $5 when you sign up using:  \(referralLink)"
        let activityController = UIActivityViewController(activityItems: [message, #imageLiteral(resourceName: "devil")], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func copyButtonTapped(_ sender: Any) {
        UIPasteboard.general.string = referralLabel.text
        self.showAlert(title: "", message: "Copied to clipboard", actionTitle: "OK")
    }
    
}
