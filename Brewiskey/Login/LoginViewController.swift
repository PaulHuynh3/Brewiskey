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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorImageView.isHidden = true
    }

    
    @IBAction func signinButtonTapped(_ sender: Any) {
        
        if emailTextField.text == ""{
            emailImageView.image = UIImage(named: "RedRectangle")
            errorImageView.isHidden = false
        }
        
        if passwordTextfield.text == ""{
            passwordImageView.image = UIImage(named: "RedRectangle")
            errorImageView.isHidden = false
        }
        
        if let email = emailTextField.text, let password = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in

                if let user = user {
                    //save user to nsdefault or something
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.transitionToMarketPlace()
                    
                } else {
                    let alert = UIAlertController(title: "Login Error", message: "Username or password is incorrect", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
            
        }

    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        performSegue(withIdentifier:"signUpIdentifier", sender: self)
    }
    


}

