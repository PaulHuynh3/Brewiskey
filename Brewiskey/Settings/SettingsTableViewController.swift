//
//  SettingsTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-16.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!

    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserObject()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: navigateToMyAccount()
        case 1: navigateToReferFriend()
        case 2: navigateToPromoCode()
        case 3: print("past orders")
        case 4: navigateToPayment()
        case 5: webPortalHelpPage()
        case 6: handleLogout()
            
        default: print("default")
        }
    }
    
    fileprivate func navigateToReferFriend() {
        performSegue(withIdentifier: "referralSegue", sender: nil)
    }
    
    fileprivate func webPortalHelpPage() {
        guard let url = URL(string: "http://brewiskey.com/support/") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    fileprivate func navigateToMyAccount() {
        performSegue(withIdentifier: "accountSegue", sender: nil)
    }
    
    fileprivate func navigateToPromoCode() {
        performSegue(withIdentifier: "promoCodeSegue", sender: nil)
    }
    
    fileprivate func navigateToPayment() {
        performSegue(withIdentifier: "paymentSegue", sender: nil)
    }
    
    fileprivate func fetchUserObject() {
        if let uid = Auth.auth().currentUser?.uid {
            FirebaseAPI.fetchDatabaseCurrentUser(uid: uid) { [weak self] (user) in
              self?.user = user
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accountSegue" {
            let myAccountTableViewController = segue.destination as! MyAccountTableViewController
            myAccountTableViewController.user = self.user
        }
        
        if segue.identifier == "paymentSegue" {
            let paymentViewController = segue.destination as! PaymentViewController
            paymentViewController.user = self.user
        }
    }
    
    //handle logout clear nsuserdefaults, clear any data associated with previous user..
    private func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
            return
        }
        let userDefaultUtils = UserDefaultsUtils()
        userDefaultUtils.clearUserDefaults()
        let fbsdkLogin = FBSDKLoginManager()
        fbsdkLogin.logOut()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToLogin()
    }

}
