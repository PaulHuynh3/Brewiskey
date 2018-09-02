//
//  ViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
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
    fileprivate var onboardingCheckUtils: OnboardingCheckUtils?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        firstNameTextfield.delegate = self
        lastNameTextfield.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        errorCircleImageView.isHidden = true
        activityIndicatorView.isHidden = true
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
            if user.isAnonymous {
                let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                user.linkAndRetrieveData(with: credential) { (authDataResult, error) in
                    if let error = error {
                        self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "OK")
                        return
                    }
                    guard let uid = authDataResult?.user.uid else {return}
                    self.activityIndicatorView.isHidden = false
                    self.activityIndicatorView.startAnimating()
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

                            storageRef.downloadURL(completion: { (imageUrl, downloadError) in
                            FirebaseDynamicLinkHelper().createReferralDynamicLink(completion: { (shortLink: URL?, firebaseError: String?) in
                                StripeAPI().createCustomer(email: email, completion: { (stripeId: String?, stripeError: String?) in
                                    
                                    DispatchQueue.main.async {
                                        var profileImageURL = "imageUrl"
                                        if let error = downloadError {
                                            print(error.localizedDescription)
                                            return
                                        }
                                        if let url = imageUrl {
                                            profileImageURL = url.absoluteString
                                        }
                                        
                                        if let firebaseError = firebaseError {
                                            self.showAlert(title: "Error", message: firebaseError, actionTitle: "OK")
                                            return
                                        }
                                        if let stripeError = stripeError {
                                            self.showAlert(title: "Error", message: stripeError, actionTitle: "OK")
                                            return
                                        }
                                        guard let link = shortLink else {
                                            self.showAlert(title: "Error", message: "Referal Link nil", actionTitle: "OK")
                                            return
                                        }
                                        
                                        let values = ["first_name": firstName, "last_name": lastName, "email": email, "profile_image_url": profileImageURL, "referral_Link": link.absoluteString, "stripe_Id": stripeId]
                                        
                                        let userDefault = UserDefaults.standard
                                        userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                                        userDefault.set(uid, forKey: kUserInfo.kUserId)
                                        userDefault.set(true, forKey: kUserInfo.kNewUser)
                                        userDefault.set(firstName, forKey: kUserInfo.kFirstName)
                                        userDefault.set(lastName, forKey: kUserInfo.kLastName)
                                        userDefault.set(email, forKey: kUserInfo.kEmail)
                                        userDefault.set(shortLink, forKey: kUserInfo.kReferralLink)
                                        userDefault.set(stripeId, forKey: kUserInfo.kStripeId)
                                        
                                        
                                        self.registerUserNavigateMarketPlace(uid, values: values as [String : AnyObject])
                                        self.activityIndicatorView.stopAnimating()
                                        BrewiskeyAnalytics().track(event: .userSignupEmail)
                                        BrewiskeyAnalytics().track(event: .signupWithReferral)
                                    }
                                    
                                })
                            })
                        })
                    })
                    }
                }
            } else {
                registerNewUser(email: email, password: password, firstName: firstName, lastName: lastName)
            }
        } else {
            registerNewUser(email: email, password: password, firstName: firstName, lastName: lastName)
        }
    }
    
    private func registerNewUser(email: String, password: String, firstName: String, lastName: String) {
        let onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        
        Auth.auth().createUser(withEmail: email, password: password) {(authDataResult, error) in
            if let error = error {
                onboardingCheckUtils.displayError(error.localizedDescription)
                return
            }
            
            guard let uid = authDataResult?.user.uid else {return}
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
            //successfully authenticated user now upload picture to storage.
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            guard let profileImage = self.uploadPictureImageView.image else {return}
            
            //compresses the image
            if let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    storageRef.downloadURL(completion: { (imageUrl, downloadError) in
                        FirebaseDynamicLinkHelper().createReferralDynamicLink(completion: { (shortLink: URL?, firebaseError: String?) in
                            StripeAPI().createCustomer(email: email, completion: { (stripeId: String?, stripeError: String?) in
                                
                                DispatchQueue.main.async {
                                    var profileImageURL = "imageUrl"
                                    if let error = downloadError {
                                        print(error.localizedDescription)
                                        return
                                    }
                                    if let url = imageUrl {
                                        profileImageURL = url.absoluteString
                                    }
                                    
                                    if let firebaseError = firebaseError {
                                        self.showAlert(title: "Error", message: firebaseError, actionTitle: "OK")
                                        return
                                    }
                                    if let stripeError = stripeError {
                                        self.showAlert(title: "Error", message: stripeError, actionTitle: "OK")
                                        return
                                    }
                                    guard let link = shortLink else {
                                        self.showAlert(title: "Error", message: "Referal Link nil", actionTitle: "OK")
                                        return
                                    }
                                    
                                    let values = ["first_name": firstName, "last_name": lastName, "email": email, "profile_image_url": profileImageURL, "referral_Link": link.absoluteString, "stripe_Id": stripeId]
                                    
                                    let userDefault = UserDefaults.standard
                                    userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                                    userDefault.set(uid, forKey: kUserInfo.kUserId)
                                    userDefault.set(true, forKey: kUserInfo.kNewUser)
                                    userDefault.set(firstName, forKey: kUserInfo.kFirstName)
                                    userDefault.set(lastName, forKey: kUserInfo.kLastName)
                                    userDefault.set(email, forKey: kUserInfo.kEmail)
                                    userDefault.set(shortLink, forKey: kUserInfo.kReferralLink)
                                    userDefault.set(stripeId, forKey: kUserInfo.kStripeId)
                                    userDefault.set(false, forKey: kUserInfo.kIsAnonymousUser)
                                    
                                    self.registerUserNavigateMarketPlace(uid, values: values as [String : AnyObject])
                                    self.activityIndicatorView.stopAnimating()
                                    BrewiskeyAnalytics().track(event: .userSignupEmail)
                                    BrewiskeyAnalytics().track(event: .signupWithReferral)
                                }
                                
                            })
                        })
                    })
                    
                })
            }
        }
    }
    
    func registerUserNavigateMarketPlace(_ uid:String, values: [String:AnyObject]){
        let userReference = Database.database().reference().child("users").child(uid)
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
    
    @IBAction func privacyPolicyLinkTapped(_ sender: Any) {
        let link = "https://brewiskey.com/privacy-policy/"
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //Textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            uploadPictureImageView.layer.cornerRadius = uploadPictureImageView.frame.size.width / 2
            uploadPictureImageView.clipsToBounds = true
            uploadPictureImageView.layer.borderWidth = 3.0
            uploadPictureImageView.layer.borderColor = UIColor.white.cgColor
            uploadPictureImageView.contentMode = .scaleToFill
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
