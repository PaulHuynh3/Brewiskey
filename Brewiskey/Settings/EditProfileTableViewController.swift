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
    
    @IBOutlet weak var numberTextfield: UITextField!
    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var provinceTextfield: UITextField!
    @IBOutlet weak var postalCodeTextfield: UITextField!
    
    @IBOutlet weak var saveEditButton: UIBarButtonItem!
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUserProfile()
        editingInProgress()
    }
    
    //todo: use textfield delegate to show when a text has been changed and if its change make the save button pop up.
    fileprivate func isEditingInProgress(){
        guard let number = numberTextfield.text, let street = streetTextfield.text, let city = cityTextfield.text, let province = provinceTextfield.text, let postalCode = postalCodeTextfield.text else {
            return
        }
        
        if number.trim() == "" || street.trim() == "" || city.trim() == "" || province.trim() == "" || postalCode.trim() {
            self.navigationItem.rightBarButtonItem = saveEditButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    fileprivate func layoutUserProfile(){
    var fullName = ""
        if let firstName = user.firstName, let lastName = user.lastName {
        fullName = firstName + " " + lastName
            fullNameLabel.text = fullName
        }
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
            profileImageView.clipsToBounds = true
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

extension EditProfileTableViewController: UITextFieldDelegate {
    
    
}
