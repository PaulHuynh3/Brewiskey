//
//  BaseOnboardingView.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-05.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class BaseOnboardingView: UIView {
    var navigateUserDelegate: BaseOnboardingScreenDelegate!
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        navigateUserDelegate.loginUser()
    }
    
    @IBAction func FacebookButtonTapped(_ sender: Any) {
        navigateUserDelegate.signupWithFacebook()
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        navigateUserDelegate.signupWithEmail()
    }
    
}
