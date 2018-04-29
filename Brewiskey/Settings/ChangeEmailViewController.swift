//
//  ChangeEmailViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-28.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class ChangeEmailViewController: UIViewController {
    var updateUserDelegate: updateUserDelegate?
    @IBOutlet weak var newEmailTextfield: UITextField!
    @IBOutlet weak var confirmEmailTextfield: UITextField!
    fileprivate var onboardingCheckUtils: OnboardingCheckUtils?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        setTextfieldDelegates()
    }
    
    private func setTextfieldDelegates(){
        newEmailTextfield.delegate = self
        confirmEmailTextfield.delegate = self
    }


    @IBAction func changeEmailTapped(_ sender: Any) {
        
        guard let email = newEmailTextfield.text, let confirmEmail = confirmEmailTextfield.text else {
            return
        }
        
        if email.trim() == "" || confirmEmail.trim() == "" {
            let message = "Please fill out mandatory fields"
            onboardingCheckUtils?.displayError(message)
            return
        }
        
            if !checkValidEmail(email) {
                let message = "Please enter a valid email"
                onboardingCheckUtils?.displayError(message)
                return
            }

        if checkEmailMatches(email: email, confirmEmail: confirmEmail) {
            if let uid = Auth.auth().currentUser?.uid {
                
                Auth.auth().currentUser?.updateEmail(to: email, completion: {[weak self] (error: Error?) in
                    if let error = error {
                        self?.onboardingCheckUtils?.displayError(error.localizedDescription)
                        return
                    }
                    UserDefaults.standard.set(email, forKey: kUserInfo.kEmail)
                    self?.displayConfirmEmailChanged()
                    self?.updateUserIntoDatabase(uid, values: ["email": email] as [String: AnyObject])
                    self?.newEmailTextfield.text = ""
                    self?.confirmEmailTextfield.text = ""
                    self?.updateUserDelegate?.refreshUserEmail()
                })
                
            }
        } else {
            let message = "Email does not match"
            onboardingCheckUtils?.displayError(message)
        }
        
    }
    
    private func updateUserIntoDatabase(_ uid:String, values: [String: AnyObject]){
        let userReference = Database.database().reference().child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: {(error, databaseRef) in
            if let error = error {
                print(error, #line)
                return
            }
        })
    }
    
    fileprivate func checkValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    fileprivate func checkEmailMatches(email: String, confirmEmail: String) -> Bool {
        if email == confirmEmail {
            return true
        } else {
            return false
        }
    }
    fileprivate func displayConfirmEmailChanged() {
        let title = "Success"
        let message = "Email was successfully changed."
        let actionTitle = "OK"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}

extension ChangeEmailViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
