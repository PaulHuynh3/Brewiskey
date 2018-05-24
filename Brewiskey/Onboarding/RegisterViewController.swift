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
    fileprivate var onboardingCheckUtils: OnboardingCheckUtils?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        firstNameTextfield.delegate = self
        lastNameTextfield.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
              let password = passwordTextField.text else {
                return
        }
        
        let onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        
        if !checkBlankFields(firstName: firstName, lastName: lastName, email: email, password: password){
            let errorMessage = "Please fill out all mandatory fields."
            onboardingCheckUtils.displayError(errorMessage)
            return
        }
        
        if !onboardingCheckUtils.checkValidEmail(email){
            let errorMessage = "Please enter a valid email."
            emailImageView.image = UIImage(named: "RedRectangle")
            onboardingCheckUtils.displayError(errorMessage)
            return
        } else {
            emailImageView.image = UIImage(named: "BlueRectangle")
        }
        
        if !onboardingCheckUtils.checkPasswordComplexity(password){
            let errorMessage = "Password must be at least 8 characters with at least one uppercase letter, one number and one special character."
            onboardingCheckUtils.displayError(errorMessage)
            passwordImageView.image = UIImage(named: "RedRectangle")
            return
        } else {
            passwordImageView.image = UIImage(named: "BlueRectangle")
        }
        
        if onboardingCheckUtils.checkEmailPasswordMatch(email: email, password: password){
            let errorMessage = "Email and password may not be the same!"
            onboardingCheckUtils.displayError(errorMessage)
            return
        }
        
        //link anonymous user that came in with referral link to an account with email/password
        if let user = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            user.link(with: credential) { (user, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "OK")
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
                            
                            FirebaseDynamicLinkHelper().createReferralDynamicLink(completion: { (shortLink: URL?, error: String?) in
                                if let error = error {
                                    self.showAlert(title: "Error", message: error, actionTitle: "OK")
                                    return
                                }
                                guard let link = shortLink else {
                                    self.showAlert(title: "Error", message: "Referal Link nil", actionTitle: "OK")
                                    return
                                }
                                
                                let values = ["first_name": firstName, "last_name": lastName, "email": email, "profile_image_url": profileImageURL, "referral_Link": link.absoluteString]
                                
                                let userDefault = UserDefaults.standard
                                userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                                userDefault.set(uid, forKey: kUserInfo.kUserId)
                                userDefault.set(true, forKey: kUserInfo.kNewUser)
                                userDefault.set(firstName, forKey: kUserInfo.kFirstName)
                                userDefault.set(lastName, forKey: kUserInfo.kLastName)
                                userDefault.set(email, forKey: kUserInfo.kEmail)
                                userDefault.set(shortLink, forKey: kUserInfo.kReferralLink)
                                
                                self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                                BrewiskeyAnalytics().track(event: .userSignupEmail)
                                BrewiskeyAnalytics().track(event: .signupWithReferral)
                            })
                        }
                    })
                }
            }
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                if let error = error {
                    onboardingCheckUtils.displayError(error.localizedDescription)
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
                            
                            FirebaseDynamicLinkHelper().createReferralDynamicLink(completion: { (shortLink: URL?, error: String?) in
                                if let error = error {
                                    self.showAlert(title: "Error", message: error, actionTitle: "OK")
                                    return
                                }
                                guard let link = shortLink else {
                                    self.showAlert(title: "Error", message: "Referal Link nil", actionTitle: "OK")
                                    return
                                }
                                
                                let values = ["first_name": firstName, "last_name": lastName, "email": email, "profile_image_url": profileImageURL, "referral_Link": link.absoluteString]
                                
                                let userDefault = UserDefaults.standard
                                userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                                userDefault.set(uid, forKey: kUserInfo.kUserId)
                                userDefault.set(true, forKey: kUserInfo.kNewUser)
                                userDefault.set(firstName, forKey: kUserInfo.kFirstName)
                                userDefault.set(lastName, forKey: kUserInfo.kLastName)
                                userDefault.set(email, forKey: kUserInfo.kEmail)
                                userDefault.set(shortLink, forKey: kUserInfo.kReferralLink)
                                
                                self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                                BrewiskeyAnalytics().track(event: .userSignupEmail)
                            })
                        }
                    })
                }
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
            if firstName.trim() == "" {
                firstNameImageview.image = UIImage(named: "RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                firstNameImageview.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            if lastName.trim() == "" {
                lastNameImageview.image = UIImage(named: "RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                lastNameImageview.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            
            if email.trim() == "" {
                emailImageView.image = UIImage(named: "RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                emailImageView.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            
            if password.trim() == "" {
                passwordImageView.image = UIImage(named:"RedRectangle")
                errorCircleImageView.isHidden = false
            } else {
                passwordImageView.image = UIImage(named: "BlueRectangle")
                errorCircleImageView.isHidden = true
            }
            return false
        }
        return true
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

