//
//  MoreTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class MoreTableViewController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser?.uid
        fetchAndConfigureProfile()
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:print("profile")
        case 1:print("refer a friend")
        case 2:print("promo code")
        case 3:print("notifications")
        case 4:print("past orders")
        case 5:print("payment")
        case 6:print("settings")
        case 7:print("help")
        case 8: handleLogout()
            
        default: print("default")
        }
        
    }
    
    private func fetchAndConfigureProfile(){
        FirebaseAPI.fetchDatabaseCurrentUser(uid: uid!) { (user) in
           if let firstName = UserDefaults.standard.string(forKey: kUserInfo.kFirstName),
            let lastName = UserDefaults.standard.string(forKey: kUserInfo.kLastName) {
            self.profileNameLabel.text = firstName + " " + lastName
            }
            self.profileEmailLabel.text = user.email
            if let profileImageUrl = user.profileImageUrl {
                self.profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
            }
        }
        
        if let currentUser = Auth.auth().currentUser{
            profileNameLabel.text = currentUser.displayName
            
            guard let imageUrl = currentUser.photoURL else {return}
            FirebaseAPI.loadImageFromUrl(url: imageUrl, completion: { (downloadedImage) in
                self.profileImageView.image = downloadedImage
            })
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
        
        DispatchQueue.main.async {
            let userDefault = UserDefaults.standard
            userDefault.set(false, forKey: kUserInfo.kLoginStatus)
            userDefault.set(nil, forKey: kUserInfo.kUserId)
            userDefault.set(nil, forKey: kUserInfo.kEmail)
            userDefault.set(nil, forKey: kUserInfo.kFirstName)
            userDefault.set(nil, forKey: kUserInfo.kLastName)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToLogin()
        }
    }
    
}
