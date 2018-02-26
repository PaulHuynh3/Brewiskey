//
//  MarketPlaceCollectionViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-23.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MarketTableViewController: UITableViewController {
    var uid: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
         handleLogout()
        } else {
//            fetchUserAndSetupNavBarTitle()
        }
        
    }
    
    func handleLogout(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToLogin()
        }
        
    }
    
    
    // MARK: - Tableview data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
    }
    

}



