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
        case 0: navigateToProfile()
        case 1:print("refer a friend")
        case 2:print("promo code")
        case 3:print("notifications")
        case 4:print("past orders")
        case 5:print("payment")
        case 6:print("help")
        case 7: handleLogout()
            
        default: print("default")
        }
        
    }
    
    fileprivate func navigateToProfile(){
        performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    fileprivate func fetchUserObject(){
        if let uid = Auth.auth().currentUser?.uid {
            FirebaseAPI.fetchDatabaseCurrentUser(uid: uid) { [weak self] (user) in
              self?.user = user
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let profileTableViewController = segue.destination as! ProfileTableViewController
            profileTableViewController.user = self.user
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
        clearUserDefaults()
        let fbsdkLogin = FBSDKLoginManager()
        fbsdkLogin.logOut()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToLogin()
    }
    
    fileprivate func clearUserDefaults(){
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: kUserInfo.kLoginStatus)
        userDefault.set(nil, forKey: kUserInfo.kUserId)
        userDefault.set(nil, forKey: kUserInfo.kEmail)
        userDefault.set(nil, forKey: kUserInfo.kFirstName)
        userDefault.set(nil, forKey: kUserInfo.kLastName)
    }


    


}
