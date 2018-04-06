//
//  ViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var uploadPictureImageView: UIImageView!
    @IBOutlet weak var firstNameImageview: UIImageView!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameImageview: UIImageView!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorCircleImageView: UIImageView!
    let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorCircleImageView.isHidden = true
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createAccountTapped(_ sender: Any) {
        //            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in   }) verifying email... implement later on?
        guard let firstName = firstNameTextfield.text,
              let lastName = lastNameTextfield.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        if !checkBlankFields(firstName: firstName, lastName: lastName, email: email, password: password){
            let errorMessage = "Please fill out all mandatory fields."
            displayError(message: errorMessage)
            return
        }
        
        if !checkValidEmail(email){
            let errorMessage = "Please enter a valid email."
            displayError(message: errorMessage)
            return
        }
        
        if !checkPasswordComplexity(password){
            let errorMessage = "Password must be at least 8 characters with at least one uppercase letter, one number and one special character."
            displayError(message: errorMessage)
            return
        }
        
        if checkEmailPasswordMatch(email: email, password: password){
            let errorMessage = "Email and password may not be the same!"
            displayError(message: errorMessage)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                self.displayError(message: error.localizedDescription)
                return
            }
            
            guard let uid = user?.uid else {return}
            
            //successfully authenticated user now upload picture to storage.
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            guard let profileImage = self.uploadPictureImageView.image else {return}
            
            //compresses the image
            if let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async {
                        guard let profileImageURL = metadata?.downloadURL()?.absoluteString else {
                            return
                        }
                        
                        let values = ["firstName": firstName, "lastName": lastName, "email": email, "profileImageUrl": profileImageURL]
                        
                        let userDefault = UserDefaults.standard
                        userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                        userDefault.set(uid, forKey: kUserInfo.kUserId)
                        userDefault.set(true, forKey: kUserInfo.kNewUser)
                        userDefault.set(firstName, forKey: kUserInfo.kFirstName)
                        userDefault.set(lastName, forKey: kUserInfo.kLastName)
                        userDefault.set(email, forKey: kUserInfo.kEmail)
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(_ uid:String, values: [String:AnyObject]){
       let userReference = self.database.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
        if let error = error {
                    print(error, #line)
                    return
                 }
        print("user successfully saved into firebase db")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToMarketPlace()
                
            })
        }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func uploadPhoto(_ sender: Any) {
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
        
        let thirdAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (cancel) in
            
        }
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        alert.popoverPresentationController?.sourceView = self.uploadPictureImageView
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
            self.uploadPictureImageView.image = selectedImage
            //format picture.
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension RegisterViewController {
    
    private func checkBlankFields(firstName: String, lastName: String, email: String, password: String) -> Bool{
        if firstName.trim() == "" || lastName.trim() == "" || email.trim() == "" || password.trim() == "" {
            if firstName == "" {
                firstNameImageview.image = UIImage(named: "RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                firstNameImageview.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            if lastName == "" {
                lastNameImageview.image = UIImage(named: "RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                lastNameImageview.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            
            if email == "" {
                emailImageView.image = UIImage(named: "RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                emailImageView.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            
            if password == "" {
                passwordImageView.image = UIImage(named:"RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                passwordImageView.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            return false
        } else {
            return true
        }
    }
    
    private func checkValidEmail(_ email: String) -> Bool{
        let validateEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", validateEmailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        } else {
            return false
        }
    }
    
    private func checkPasswordComplexity(_ password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let checkForCapital = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = checkForCapital.evaluate(with: password)
        
        let lowerLetterRegEx = ".*[a-z]+.*"
        let checkForLowerCase = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        let lowerCaseResult = checkForLowerCase.evaluate(with: password)
        
        let numberRegEx  = ".*[0-9]+.*"
        let checkForNumber = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = checkForNumber.evaluate(with: password)
        
        let specialCharacterRegEx  = ".*[!@#$%^&*()-_+=]+.*"
        let checkForSpecialText = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = checkForSpecialText.evaluate(with: password)
        
        let requiredLengthRegEx = ".*.{8}+.*"
        let checkForRequiredLength = NSPredicate(format:"SELF MATCHES %@", requiredLengthRegEx)
        let requiredLengthResult = checkForRequiredLength.evaluate(with: password)
        
        if capitalResult && lowerCaseResult && numberResult && specialResult && requiredLengthResult {
            return true
        } else {
            return false
        }
    }
    
    private func checkEmailPasswordMatch(email: String, password: String) -> Bool {
        if email == password {
            return true
        } else {
            return false
        }
    }
    
    private func displayError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

