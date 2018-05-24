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
    
    func track(event: BrewiskeyAnalytics) {
        Analytics.logEvent(event.rawValue, parameters: nil)
    }
    
    enum BrewiskeyAnalytics: String {
        case signupWithReferral = "signup_with_referral"
        case userSignupEmail = "user_signup_with_email"
        case forgotPasswordScreen = "forgot_password_screen"
        case forgotPasswordTapped = "forgot_password_Tapped"
        case loginScreen = "login_screen"
        case signupEmailScreen = "signup_email_screen"
        case loginWithFacebook = "login_with_facebook"
        case loginWithEmail = "login_with_email"
        
    }
    
}
