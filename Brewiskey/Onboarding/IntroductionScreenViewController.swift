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
    var onboardingViews = [BaseOnboardingView]()
    @IBOutlet weak var onboardingScrollView: UIScrollView!
    
    override func viewDidLoad() {
        onboardingViews = createOnboardinViews()
        setupSlideScrollView(onboardingViews)
    }
    
    fileprivate func createOnboardinViews() -> [BaseOnboardingView] {
        let onboardingViewOne = "OnboardingView0"
        let onboardingViewTwo = "OnboardingView1"
        let onboardingViewThree = "OnboardingView2"
        
        let onboardingView0 = Bundle.main.loadNibNamed(onboardingViewOne, owner: nil, options: nil)?.first as! BaseOnboardingView
        let onboardingView1 = Bundle.main.loadNibNamed(onboardingViewTwo, owner: nil, options: nil)?.first as! BaseOnboardingView
        let onboardingView2 = Bundle.main.loadNibNamed(onboardingViewThree, owner: nil, options: nil)?.first as! BaseOnboardingView
        
        let onboardingViews = [onboardingView0, onboardingView1, onboardingView2]
        
        for onboardingView in onboardingViews {
            onboardingView.navigateUserDelegate = self
        }
        return onboardingViews
    }
    
    fileprivate func setupSlideScrollView(_ onboardingViews: [UIView]) {
        onboardingScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        onboardingScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(onboardingViews.count), height: view.frame.height)
        onboardingScrollView.isPagingEnabled = true
        
        for i in 0 ..< onboardingViews.count {
            onboardingViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            onboardingScrollView.addSubview(onboardingViews[i])
        }
    }
}

extension IntroductionScreenViewController {
    
    private func registerUserIntoDatabaseAndLogin(_ uid:String, values: [String:AnyObject]){
        let userReference = Database.database().reference().child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (error, databaseRef) in
            print("user successfully saved into firebase db")
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToMarketPlace()
            if let error = error {
                print(error, #line)
                return
            }
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
        BrewiskeyAnalytics().track(event: .userSignupEmail)
    }
    
    func loginUser() {
        performSegue(withIdentifier: "loginIdentifier", sender: nil)
        BrewiskeyAnalytics().track(event: .loginScreen)
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
                    
                    if !UserDefaults.standard.bool(forKey: kUserInfo.isUsedReferralCode) {
                        //referred user convert it to facebook login
                        if let user = Auth.auth().currentUser {
                            
                            user.linkAndRetrieveData(with: credential, completion: { (authDataResult: AuthDataResult?, error: Error?) in
                                if let error = error {
                                    self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "OK")
                                    return
                                }
                                self.registerFacebookToFirebase(credential: credential, email: email, firstName: firstName, lastName: lastName, imageURL: imageURL)
                                
                            })
                        } else {
                            self.registerFacebookToFirebase(credential: credential, email: email, firstName: firstName, lastName: lastName, imageURL: imageURL)
                        }
                    } else {
                        self.registerFacebookToFirebase(credential: credential, email: email, firstName: firstName, lastName: lastName, imageURL: imageURL)
                    }
                })
            }
        }
    }
    
    private func registerFacebookToFirebase(credential: AuthCredential, email: String, firstName: String, lastName: String, imageURL: String) {
        
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (authDataResult: AuthDataResult?, error: Error?) in
            StripeAPI().createCustomer(email: email, completion: { (stripeId: String?, stripeError: String?) in
                FirebaseDynamicLinkHelper().createReferralDynamicLink(completion: { (shortLink: URL?, firebaseError: String?) in
                    
                    DispatchQueue.main.async {
                        guard let userId = authDataResult?.user.uid else {return}
                        if let error = error {
                            let onboardingCheckUtils = OnboardingCheckUtils(presentingViewController: self)
                            onboardingCheckUtils.displayError(error.localizedDescription)
                            return
                        }
                        guard let link = shortLink else {
                            self.showAlert(title: "Error", message: "link nil", actionTitle: "OK")
                            return
                        }
                        if let firebaseError = firebaseError {
                            self.showAlert(title: "Error", message: firebaseError, actionTitle: "OK")
                            return
                        }
                        if let stripeError = stripeError {
                            self.showAlert(title: "Error", message: stripeError, actionTitle: "OK")
                            return
                        }
                        
                        let userDefault = UserDefaults.standard
            
                        userDefault.set(link, forKey: kUserInfo.kReferralLink)
                        userDefault.set(true, forKey: kUserInfo.kLoginStatus)
                        userDefault.set(userId, forKey: kUserInfo.kUserId)
                        userDefault.set(firstName, forKey: kUserInfo.kFirstName)
                        userDefault.set(lastName, forKey: kUserInfo.kLastName)
                        userDefault.set(email, forKey: kUserInfo.kEmail)
                        userDefault.set(true, forKey: kUserInfo.kNewUser)
//                        userDefault.set(true, forKey: kUserInfo.isUsedReferralCode)
                        userDefault.set(stripeId, forKey: kUserInfo.kStripeId)
                        userDefault.set(false, forKey: kUserInfo.kIsAnonymousUser)
                        
                        let values = ["first_name": firstName, "last_name": lastName, "email": email, "profile_image_url": imageURL, "referral_Link": link.absoluteString, "stripe_Id": stripeId]
                        
                        self.registerUserIntoDatabaseAndLogin(userId, values: values as [String : AnyObject])
                        BrewiskeyAnalytics().track(event: .loginWithFacebook)
                    }
                })
            })
        })
        
    }
}
