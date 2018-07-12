//
//  UserLoginStatus.swift
//  Brewiskey
//
//  Created by Paul on 2018-07-12.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class UserLoginStatus {
    
    func handleUserState() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    
    fileprivate func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToLogin()
        }
    }
}
