//
//  NewCreditCardTableViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-27.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class NewCreditCardTableViewController: UITableViewController {
    @IBOutlet weak var creditCardNumberTextfield: UITextField!
    @IBOutlet weak var expirationDateTextfield: UITextField!
    @IBOutlet weak var cvcTextfield: UITextField!
    @IBOutlet weak var postalCodeTextfield: UITextField!
    @IBOutlet weak var nickNameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfieldDelegate()
    }
    
    fileprivate func setTextfieldDelegate() {
        creditCardNumberTextfield.delegate = self
        expirationDateTextfield.delegate = self
        cvcTextfield.delegate = self
        postalCodeTextfield.delegate = self
        nickNameTextfield.delegate = self
    }
    
    @IBAction func addNewCreditCardTapped(_ sender: Any) {
        if isUserErrorFree() {
            saveNewCreditCard()
            showAlertAndNavigateToMarket()
        }
    }
    
    //configure this so that firebase doesnt rewrite the node.
    fileprivate func saveNewCreditCard() {
        if let user = Auth.auth().currentUser {
            let userRecord = Database.database().reference().child("users").child(user.uid)
            let values = ["number": creditCardNumberTextfield.text, "expiration_date": expirationDateTextfield.text, "cvc": cvcTextfield.text, "postal_code": postalCodeTextfield.text, "nick_name": nickNameTextfield.text]
            userRecord.child("credit_card").setValue(values)
        }
    }
    
    fileprivate func showAlertAndNavigateToMarket() {
        let title = ""
        let message = "credit card was saved"
        let actionTitle = "OK"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action: UIAlertAction) in
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToMarketPlace()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // https://stackoverflow.com/questions/23888682/validate-credit-card-number
    //TODO: perform more advance checks later
    fileprivate func isUserErrorFree() -> Bool {
        if isValidCreditCard() && isValidExpirationDate() && isValidCVC() && isValidPostalCode() {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func isValidCreditCard() -> Bool {
        if creditCardNumberTextfield.text?.count == 16 {
            return true
        } else {
            let title = "Error"
            let message = "Enter valid creditcard"
            let actionTitle = "OK"
            self.showAlert(title: title, message: message, actionTitle: actionTitle)
            return false
        }
    }
    
    fileprivate func isValidExpirationDate() -> Bool {
        if expirationDateTextfield.text?.count == 4 {
            return true
        } else {
            let title = "Error"
            let message = "Enter valid date"
            let actionTitle = "OK"
            self.showAlert(title: title, message: message, actionTitle: actionTitle)
            return false
        }
    }
    
    fileprivate func isValidCVC() -> Bool {
        if cvcTextfield.text?.count == 3 {
            return true
        } else {
            let title = "Error"
            let message = "Enter valid cvc"
            let actionTitle = "OK"
            self.showAlert(title: title, message: message, actionTitle: actionTitle)
            return false
        }
    }
    
    fileprivate func isValidPostalCode() -> Bool {
        if postalCodeTextfield.text?.count == 6 {
            return true
        } else {
            let title = "Error"
            let message = "Enter valid postal code"
            let actionTitle = "OK"
            self.showAlert(title: title, message: message, actionTitle: actionTitle)
            return false
        }
    }
    
}

extension NewCreditCardTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
