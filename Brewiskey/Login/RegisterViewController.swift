//
//  ViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadPictureImageView: UIImageView!
    @IBOutlet weak var usernameImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
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
    

    @IBAction func createAccountTapped(_ sender: Any) {
        //            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in   }) verifying email... implement later on?
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else {return}
        
        textFieldCheck(username: username, email: email, password: password)
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
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
                    
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                        //add value for age, remove username and put full name
                        let values = ["username":username, "email":email, "password":password, "profileImageUrl":profileImageURL]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    }
                    
                })
            }
        }
    }
    
    private func textFieldCheck(username:String, email:String, password:String){
        
        if username == "" || email == "" || password == "" {
            if username == "" {
                usernameImageView.image = UIImage(named: "RedRectangle")
            } else {
                usernameImageView.image = UIImage(named: "BlueRectangle")
            }
            
            if email == "" {
                emailImageView.image = UIImage(named: "RedRectangle")
            } else {
                emailImageView.image = UIImage(named: "BlueRectangle")
            }
            
            if password == "" {
                passwordImageView.image = UIImage(named:"RedRectangle")
            } else {
                passwordImageView.image = UIImage(named: "BlueRectangle")
            }
            
            errorCircleImageView.isHidden = false
            let alert = UIAlertController(title: "Required", message: "Please fill out all mandatory fields", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
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


