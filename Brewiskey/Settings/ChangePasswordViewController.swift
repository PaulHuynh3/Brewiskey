//
//  ChangePasswordViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-28.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var verifyNewPasswordTextfield: UITextField!
    fileprivate var onboardingUtils : OnboardingCheckUtils?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfieldDelegates()
        onboardingUtils = OnboardingCheckUtils(presentingViewController: self)
    }
    
    fileprivate func setTextfieldDelegates() {
        oldPasswordTextfield.delegate = self
        newPasswordTextfield.delegate = self
        verifyNewPasswordTextfield.delegate = self
    }
    
    @IBAction func updatePasswordTapped(_ sender: Any) {
        
        guard let currentPassword = oldPasswordTextfield.text,
              let newPassword = newPasswordTextfield.text,
              let confirmNewPassword = verifyNewPasswordTextfield.text else {
                return
        }
        
        if isFieldsBlank(currentPassword: currentPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) {
            let message = "Please fill out all fields"
            onboardingUtils?.displayError(message)
            return
        }
        
        if isNewPasswordMatching(newPassword, confirmNewPassword) {
            isExistingPasswordValid(currentPassword) {[weak self] (success: Bool?, error: String?) in
                if let error = error {
                    self?.onboardingUtils?.displayError(error)
                }
                
                if success == true {
                    Auth.auth().currentUser?.updatePassword(to: confirmNewPassword, completion: {[weak self] (error : Error?) in
                        DispatchQueue.main.async {
                            if let error = error {
                                self?.onboardingUtils?.displayError(error.localizedDescription)
                            }
                            self?.passwordChangeSuccessMessage()
                        }
                    })
                }
            }
            
        } else {
            let message = "New password entered does not match."
            onboardingUtils?.displayError(message)
        }
    }
    
    fileprivate func passwordChangeSuccessMessage() {
        let title = "Success"
        let message = "Password was successfully changed."
        let actionTitle = "Great!"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func isFieldsBlank(currentPassword: String, newPassword: String, confirmNewPassword: String) -> Bool {
        if currentPassword.trim() == "" || newPassword.trim() == "" || confirmNewPassword.trim() == "" {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func isNewPasswordMatching(_ newPassword: String, _ verifyNewPassword: String) -> Bool {
        if newPassword == verifyNewPassword {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func isExistingPasswordValid(_ currentPassword: String, completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        let user = Auth.auth().currentUser
        if let email = user?.email, let currentPassword = oldPasswordTextfield.text {
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            
            user?.reauthenticate(with: credential, completion: { (error: Error?) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(false, error.localizedDescription)
                        return
                    }
                }
                //authentication successful
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            })
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
