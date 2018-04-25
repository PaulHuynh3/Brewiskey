//
//  BrewiskeyAnalytics.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import Firebase

class BrewiskeyAnalytics {

    func onboardingScreen(index: Int) {
        Analytics.logEvent("onboarding_screen_displayed_\(index)", parameters: nil)
    }
    
    func loginWithEmail() {
        Analytics.logEvent("user_login_with_email", parameters: nil)
    }
    
    func signupOrLoginWithFacebook() {
        Analytics.logEvent("user_signup_login_with_facebook", parameters: nil)
    }
    
    func signupEmailScreen() {
        Analytics.logEvent("signup_email_screen", parameters: nil)
    }
    
    func signupEmail() {
        Analytics.logEvent("user_signup_with_email", parameters: nil)
    }
    
    func loginScreen() {
        Analytics.logEvent("login_screen", parameters: nil)
    }
    
    func forgotPasswordScreen() {
        Analytics.logEvent("forgot_password_screen", parameters: nil)
    }
    
    func forgotPasswordSubmitted() {
        Analytics.logEvent("forgot_password_submitted", parameters: nil)
    }
    
}
