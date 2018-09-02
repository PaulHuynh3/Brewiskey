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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
        errorImageView.isHidden = true
        self.emailTextField.delegate = self
        self.passwordTextfield.delegate = self
        activityIndicatorView.isHidden = true
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
            Auth.auth().signIn(withEmail: email, password: password, completion: { (authDataResult, error) in

                if let authDataResult = authDataResult {
                    let userDefault = UserDefaults.standard
                    userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                    userDefault.set(authDataResult.user.uid, forKey: kUserInfo.kUserId)
                    userDefault.set(false, forKey: kUserInfo.kNewUser)
                    userDefault.set(email, forKey: kUserInfo.kEmail)
                    userDefault.set(false, forKey: kUserInfo.kIsAnonymousUser)
                    
                    BrewiskeyAnalytics().track(event: .loginWithEmail)
                    self.navigateToMarketPlace()
                    
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
        BrewiskeyAnalytics().track(event: .forgotPasswordScreen)
    }
    
    @IBAction func incognitoModeTapped(_ sender: Any) {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        let anonymousEmail = "paul.huynh3@gmail.com"
        Auth.auth().signInAnonymously { [weak self] (authDataResult: AuthDataResult?, error: Error?) in
            StripeAPI().createCustomer(email: anonymousEmail, completion: { (stripeId: String?, stripeError: String?) in
                FirebaseDynamicLinkHelper().createReferralDynamicLink(completion: { (shortLink: URL?, firebaseError: String?) in
                    guard let strongSelf = self else {return }
                    DispatchQueue.main.async {
                        let errorTitle = "Error"
                        let actionTitle = "OK"
                        if let error = error {
                            strongSelf.showAlert(title: errorTitle, message: error.localizedDescription, actionTitle: actionTitle)
                        }
                        if let error = stripeError {
                            strongSelf.showAlert(title: errorTitle, message: error, actionTitle: actionTitle)
                        }
                        if let error = firebaseError {
                            strongSelf.showAlert(title: errorTitle, message: error, actionTitle: actionTitle)
                        }
                        guard let link = shortLink else {return}
                        
                        BrewiskeyAnalytics().track(event: .anonymousLogin)
                        guard let uid = authDataResult?.user.uid else {return}
                        let userDefault = UserDefaults.standard
                        userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                        userDefault.set(uid, forKey: kUserInfo.kUserId)
                        userDefault.set(stripeId, forKey: kUserInfo.kStripeId)
                        userDefault.set(link, forKey: kUserInfo.kReferralLink)
                        //mark this user as anonymous stop him from purchasing
                        userDefault.set(true, forKey: kUserInfo.kIsAnonymousUser)
                        
                        let values = ["first_name": "Incognito", "last_name": "Mode", "email": "Incognito", "referral_Link": link.absoluteString, "stripe_Id": stripeId]
                        strongSelf.activityIndicatorView.isHidden = true
                        RegisterViewController().registerUserNavigateMarketPlace(uid, values: values as [String:AnyObject])
                    }
                })
            })
        }
    }
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
        let link = "https://brewiskey.com/privacy-policy/"
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func navigateToMarketPlace() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.transitionToMarketPlace()
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

