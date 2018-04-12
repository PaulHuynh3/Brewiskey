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
        emailTextField.delegate = self
        errorCircleImageView.isHidden = true
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        
        if email.trim() == "" {
            emailImageView.image = UIImage(named: "RedRectangle")
            errorCircleImageView.isHidden = false
            return
        }
        
        if !checkValidEmail(email){
            let errorMessage = "Please enter a valid email!"
            displayError(errorMessage)
            return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let error = error {
                self.displayError(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "resetPasswordIdentifier", sender: self)
            }
            
        }
        activityIndicator.stopAnimating()
    }
    
    private func checkValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: email) {
            return true
        } else {
            return false
        }
    }
    
    private func displayError(_ message: String){
        let title = "Error"
        let actionOk = "OK"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionOk, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
