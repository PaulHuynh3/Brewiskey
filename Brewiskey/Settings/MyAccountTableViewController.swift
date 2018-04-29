//
//  MyAccountTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-28.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class MyAccountTableViewController: UITableViewController {
    var user = User()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: showProfile()
        case 1: changePassword()
            
        default: print("default")
        }
        
    }
    
    fileprivate func showProfile(){
        performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    fileprivate func changePassword(){
        performSegue(withIdentifier: "passwordSegue", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let profileTableViewController = segue.destination as! ProfileTableViewController
            profileTableViewController.user = self.user
        }
    }


}
