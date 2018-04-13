//
//  ViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-21.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var passwordTextfield: UITextField!
    private var onboardingCheckUtils: OnboardingCheckUtils?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        errorImageView.isHidden = true
        self.emailTextField.delegate = self
        self.passwordTextfield.delegate = self
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextfield.text else {
                return
        }
        
        if checkForLoginEmptyFields(email: email, password: password) {
            let errorMessage = "Please fill out all fields"
            onboardingCheckUtils?.displayError(errorMessage)
            return
        }
        
        if let email = emailTextField.text, let password = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in

                if let user = user {
                    let userDefault = UserDefaults.standard
                    userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                    userDefault.set(user.uid, forKey: kUserInfo.kUserId)
                    userDefault.set(false, forKey: kUserInfo.kNewUser)
                    userDefault.set(email, forKey: kUserInfo.kEmail)
                    if UserDefaults.standard.string(forKey: kUserInfo.kFirstName) == nil || UserDefaults.standard.string(forKey: kUserInfo.kLastName) == nil {
                        UserDefaults.standard.set(user.displayName, forKey: kUserInfo.kDisplayName)
                    }
                    
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.transitionToMarketPlace()
                    
                } else {
                    let errorMessage = "Username or password is incorrect"
                    self.onboardingCheckUtils?.displayError(errorMessage)
                    return
                }
                
            })
            
        }
    }
    
   private func checkForLoginEmptyFields(email: String, password: String) -> Bool{
        if email.trim() == "" || password.trim() == "" {
            if email.trim() == "" {
                emailImageView.image = UIImage(named: "RedRectangle")
                errorImageView.isHidden = false
            } else {
                emailImageView.image = UIImage(named: "BlueRectangle")
                errorImageView.isHidden = true
            }
            
            if password.trim() == "" {
                passwordImageView.image = UIImage(named: "RedRectangle")
                errorImageView.isHidden = false
            } else {
                emailImageView.image = UIImage(named: "BlueRectangle")
                errorImageView.isHidden = true
            }
            return true
        }
        return false
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        performSegue(withIdentifier: "forgotPasswordSegue", sender: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

