//
//  UpdateCreditCardViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-08.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Firebase

class UpdateCreditCardViewController: UIViewController {
    @IBOutlet weak var typeOfCardLabel: UILabel!
    @IBOutlet weak var currentCreditCardLabel: UILabel!
    @IBOutlet weak var expirationDateTextfield: UITextField!
    @IBOutlet weak var postalCodeTextfield: UITextField!
    
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCreditCardDetail()
    }
    
    fileprivate func showCreditCardDetail() {
        currentCreditCardLabel.text = user.creditCard.number
        expirationDateTextfield.text = user.creditCard.expirationDate
        postalCodeTextfield.text = user.creditCard.postalCode
        guard let cardType = user.creditCard.number else {return}
        
        if cardType.hasPrefix("4") {
            typeOfCardLabel.text = "visacard"
        } else {
            typeOfCardLabel.text = "mastercard"
        }
        
    }
    
    @IBAction func updateCardTapped(_ sender: Any) {
        if isUserErroFree() {
            showAlertAndUpdateCreditCardAndNavigateToMarket()
        }
    }
    
    @IBAction func deleteCardTapped(_ sender: Any) {
        //delete from firebase
    }
    
    fileprivate func showAlertAndUpdateCreditCardAndNavigateToMarket() {
        let title = ""
        let message = "credit card was updated"
        let actionTitle = "OK"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action: UIAlertAction) in
            self.updateCreditCard()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.transitionToMarketPlace()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func updateCreditCard() {
        if let currentUser = Auth.auth().currentUser {
            let userRecord = Database.database().reference().child("users").child(currentUser.uid)
            let values = ["number": user.creditCard.number, "expiration_date": expirationDateTextfield.text, "cvc": user.creditCard.cvcNumber, "postal_code": postalCodeTextfield.text, "nick_name": user.creditCard.nickname]
            userRecord.child("credit_card").setValue(values)
        }
    }
    
    fileprivate func isUserErroFree() -> Bool {
        if isValidExpirationDate() && isValidPostalCode() {
            return true
        } else {
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
