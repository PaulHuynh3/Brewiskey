//
//  OnboardingCheck.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-06.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class OnboardingCheckUtils {
    
    private weak var presentingViewController: UIViewController?
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func displayError(_ message: String){
        let title = "Error"
        let actionOk = "OK"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionOk, style: .default, handler: nil)
        alert.addAction(okAction)
        presentingViewController?.present(alert, animated: true, completion: nil)
    }
    
    func checkValidEmail(_ email: String) -> Bool{
        let validateEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", validateEmailRegEx)
        if emailTest.evaluate(with: email) {
            return true
        } else {
            return false
        }
    }
    
    func checkPasswordComplexity(_ password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let checkForCapital = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = checkForCapital.evaluate(with: password)
        
        let lowerLetterRegEx = ".*[a-z]+.*"
        let checkForLowerCase = NSPredicate(format:"SELF MATCHES %@", lowerLetterRegEx)
        let lowerCaseResult = checkForLowerCase.evaluate(with: password)
        
        let numberRegEx  = ".*[0-9]+.*"
        let checkForNumber = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = checkForNumber.evaluate(with: password)
        
        let specialCharacterRegEx  = ".*[!@#$%^&*()-_+=]+.*"
        let checkForSpecialText = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = checkForSpecialText.evaluate(with: password)
        
        let requiredLengthRegEx = ".*.{8}+.*"
        let checkForRequiredLength = NSPredicate(format:"SELF MATCHES %@", requiredLengthRegEx)
        let requiredLengthResult = checkForRequiredLength.evaluate(with: password)
        
        if capitalResult && lowerCaseResult && numberResult && specialResult && requiredLengthResult {
            return true
        } else {
            return false
        }
    }
    
    func checkEmailPasswordMatch(email: String, password: String) -> Bool {
        if email == password {
            return true
        } else {
            return false
        }
    }
}
