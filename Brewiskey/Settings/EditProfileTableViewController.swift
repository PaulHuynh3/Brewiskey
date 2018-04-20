//
//  EditProfileTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-19.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user = User()
    
//    var user : User? = nil {
//        didSet {
//            fetchUserObject()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        layoutUserProfile()
    }
    
    fileprivate func layoutUserProfile(){
    var fullName = ""
        if let firstName = user.firstName, let lastName = user.lastName {
        fullName = firstName + " " + lastName
            fullNameLabel.text = fullName
        }
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
//            profileImageView.layer.borderWidth = 1
//            profileImageView.layer.masksToBounds = false
//            profileImageView.layer.borderColor = UIColor.black.cgColor
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
            profileImageView.clipsToBounds = true
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
