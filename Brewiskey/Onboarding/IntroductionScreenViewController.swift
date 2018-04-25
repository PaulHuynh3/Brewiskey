//
//  IntroductionScreenViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-05.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

protocol BaseOnboardingScreenDelegate{
    func signupWithEmail()
    func signupWithFacebook()
    func loginUser()
}

class IntroductionScreenViewController: UIViewController {
    
    @IBOutlet weak var onboardingView: UIView!
    var index = 0
    var kNumberOfOnboardingScreens = 4
    var kRequiredNumberToTapForward = CGFloat(0.3)
    
    override func viewDidLoad() {
        loadOnboardingScreens()
        setupTapGesture()
        setupSwipeGesture()
    }
    
    private func loadOnboardingScreens(){
        guard let objects = Bundle.main.loadNibNamed("OnboardingView\(self.index)", owner: nil, options: [:]) else {
            return
        }
        guard let view = objects[0] as? BaseOnboardingView else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.navigateUserDelegate = self
        
        for subview in self.onboardingView.subviews {
            subview.removeFromSuperview()
        }
        self.onboardingView.addSubview(view)
        
        let views = [ //necessary to configure the view's constraint's..
            "onboardingView" : view
        ]
        self.onboardingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[onboardingView]|", options: [], metrics: nil, views: views))
        self.onboardingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[onboardingView]|", options: [], metrics: nil, views: views))
        
        BrewiskeyAnalytics().onboardingScreen(index: self.index)
    }
    
    private func setupTapGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer){
        if sender.state == .ended {
            let tapLocation = sender.location(in: self.view)
            
            if tapLocation.x > self.view.frame.size.width * kRequiredNumberToTapForward {
                guard index < kNumberOfOnboardingScreens else {
                    return
                }
                index += 1
            } else { //tapped backwards
                guard index > 0 else {
                    return
                }
                index -= 1
            }
            self.loadOnboardingScreens()
        }
    }
    
    private func setupSwipeGesture(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            if sender.direction == UISwipeGestureRecognizerDirection.left{
                guard index < kNumberOfOnboardingScreens else {
                    return
                }
                index += 1
            } else if sender.direction == UISwipeGestureRecognizerDirection.right{
                guard index > 0 else {
                    return
                }
                index -= 1
            }
            self.loadOnboardingScreens()
        }
    }
    
}

extension IntroductionScreenViewController {
    
    private func registerUserIntoDatabaseAndLogin(_ uid:String, values: [String:AnyObject]){
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
    
    private func displayError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension IntroductionScreenViewController: BaseOnboardingScreenDelegate {
    func signupWithEmail() {
        performSegue(withIdentifier: "signUpIdentifier", sender: nil)
        BrewiskeyAnalytics().signupEmailScreen()
    }
    
    func loginUser() {
        performSegue(withIdentifier: "loginIdentifier", sender: nil)
        BrewiskeyAnalytics().loginScreen()
    }
    
    func signupWithFacebook() {
        let facebookEmail = "email"
        let publicProfile = "public_profile"
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: [publicProfile, facebookEmail], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let result = result else{return}
            let fbLoginResult: FBSDKLoginManagerLoginResult = result
            
            //if user cancel the login
            if result.isCancelled {
                return
            }
            if fbLoginResult.grantedPermissions.contains(facebookEmail){
                let jsonEmail = "email"
                let jsonId = "id"
                let jsonFirstName = "first_name"
                let jsonLastName = "last_name"
                FacebookAPI.userFacebookData(completion: { (facebookDict) in
                    
                    guard let email = facebookDict[jsonEmail] as? String,
                        let socialMediaId = facebookDict[jsonId] as? String,
                        let firstName = facebookDict[jsonFirstName] as? String,
                        let lastName = facebookDict[jsonLastName] as? String else {
                            return
                    }
                    
                    guard let imageURL = ((facebookDict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String else {
                        return
                    }
                    
                    //convert fb Access token to firebase's token.
                    guard let accessToken = FBSDKAccessToken.current() else {
                        print("Failed to get access token")
                        return
                    }
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        if let error = error {
                            let onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
                            onboardingCheckUtils.displayError(error.localizedDescription)
                            return
                        }
                        DispatchQueue.main.async {
                            
                            guard let userId = user?.uid else {return}
                            let userDefault = UserDefaults.standard
                            userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                            userDefault.set(userId, forKey: kUserInfo.kUserId)
                            userDefault.set(true, forKey: kUserInfo.kNewUser)
                            userDefault.set(firstName, forKey: kUserInfo.kFirstName)
                            userDefault.set(lastName, forKey: kUserInfo.kLastName)
                            userDefault.set(email, forKey: kUserInfo.kEmail)
                            
                            let values = ["firstName": firstName, "lastName": lastName, "email": email, "profileImageUrl": imageURL]
                            
                            self.registerUserIntoDatabaseAndLogin(userId, values: values as [String : AnyObject])
                            BrewiskeyAnalytics().signupOrLoginWithFacebook()
                        }
                    })
                    
                })
            }
        }
    }
}
