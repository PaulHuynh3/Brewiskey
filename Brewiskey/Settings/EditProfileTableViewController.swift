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
    
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var numberTextfield: UITextField!
    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var provinceTextfield: UITextField!
    @IBOutlet weak var postalCodeTextfield: UITextField!
    @IBOutlet weak var unitNumberOptionalTextfield: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUserProfile()
        setTextfieldDelegates()
        if isTextfieldEmpty() {
            showSaveButton()
        }
        setUpTapGestureProfileImage()
    }
    
    fileprivate func setUpTapGestureProfileImage(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    fileprivate func setTextfieldDelegates(){
        firstNameTextfield.delegate = self
        lastNameTextfield.delegate = self
        ageTextfield.delegate = self
        numberTextfield.delegate = self
        streetTextfield.delegate = self
        cityTextfield.delegate = self
        provinceTextfield.delegate = self
        postalCodeTextfield.delegate = self
    }
    
    //todo: use textfield delegate to show when a text has been changed and if its change make the save button pop up.
    fileprivate func isTextfieldEmpty() -> Bool {
        
        if let number = numberTextfield.text, let street = streetTextfield.text, let city = cityTextfield.text, let province = provinceTextfield.text, let postalCode = postalCodeTextfield.text {
            
            if number.trim() == "" || street.trim() == "" || city.trim() == "" || province.trim() == "" || postalCode.trim() == "" {
                return true
            }
        }
        return false
    }
    
    fileprivate func showSaveButton(){
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    fileprivate func hideSaveButton(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
    }
    
    fileprivate func layoutUserProfile(){
        if let firstName = user.firstName {
            firstNameTextfield.text = firstName
        }
        if let lastName = user.lastName {
            lastNameTextfield.text = lastName
        }
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
            profileImageView.clipsToBounds = true
        }
        
        //set after user edits their profile.
        if let age = user.age {
            ageTextfield.text = age
        }
        if let number = user.address.number {
            numberTextfield.text = number
        }
        if let street = user.address.street {
            streetTextfield.text = street
        }
        if let city = user.address.city {
            cityTextfield.text = city
        }
        if let province = user.address.province {
            provinceTextfield.text = province
        }
        if let postalCode = user.address.postalCode {
            postalCodeTextfield.text = postalCode
        }
        if let unitNumber = user.address.unitNumber {
            unitNumberOptionalTextfield.text = unitNumber
        }
    }
    
    @IBAction func saveProfileTapped(_ sender: Any) {
        //save all the text on the current screen and picture and update the user's info.
        let editedFirstName = firstNameTextfield.text
        let editedLastName = lastNameTextfield.text
        let editedAge = ageTextfield.text
        let editedImage = profileImageView.image
        let editedNumber = numberTextfield.text
        let editedStreet = streetTextfield.text
        let editedCity = cityTextfield.text
        let editedProvince = provinceTextfield.text
        let editedPostalCode = postalCodeTextfield.text
        
        hideSaveButton()
    }

}

extension EditProfileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showSaveButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        showSaveButton()
        return true
    }
}

extension EditProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func profileImageTapped(_ sender: Any) {
        print("test")
        let alert = UIAlertController(title: "Edit Profile Picture", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let firstAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default) { (actionOne) in
            let imagePickerController = UIImagePickerController()
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Sorry camera not available")
            }
        }
        
        let secondAction = UIAlertAction(title: "Choose photo from library", style: UIAlertActionStyle.default) { (actionTwo) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let thirdAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        alert.popoverPresentationController?.sourceView = profileImageView
        present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
}
