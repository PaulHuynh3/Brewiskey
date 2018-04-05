//
//  ForgotPasswordViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-22.
//  Copyright © 2018 Paul. All rights reserved.
//
import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorCircleImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorCircleImageView.isHidden = true
    }
    
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        
        if emailTextField.text == ""{
            emailImageView.image = UIImage(named: "RedRectangle")
            errorCircleImageView.isHidden = false
            return
        }
        guard let email = emailTextField.text else {return}
        
        activityIndicator.startAnimating()
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "The email is not valid", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "resetPasswordIdentifier", sender: self)
            }
            
        }
        activityIndicator.stopAnimating()
    }
    
}

class EmailSentViewController: UIViewController {
    
    @IBAction func soundsGoodButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}

