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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        errorCircleImageView.isHidden = true
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text else {
            return
        }
        
        let onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        if email.trim() == "" {
            emailImageView.image = UIImage(named: "RedRectangle")
            errorCircleImageView.isHidden = false
            return
        }
   
        if !onboardingCheckUtils.checkValidEmail(email){
            let errorMessage = "Please enter a valid email!"
            onboardingCheckUtils.displayError(errorMessage)
            return
        }
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                onboardingCheckUtils.displayError(error.localizedDescription)
                 activityIndicator.stopAnimating()
            } else {
                self.performSegue(withIdentifier: "resetPasswordIdentifier", sender: self)
                activityIndicator.stopAnimating()
                BrewiskeyAnalytics().track(event: .forgotPasswordTapped)
            }
        }
        
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
