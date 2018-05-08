//
//  PromoCodeViewController.swift
//  Brewiskey
//
//  Created by Paul on 2018-05-08.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit

class PromoCodeViewController: UIViewController {
    
    struct NotificationIdentifier {
        static let promoCodeAdded = NSNotification.Name(rawValue: "PromoCodeAdded")
    }
    
    @IBOutlet weak var appliedPromoCodeLabel: UILabel!
    @IBOutlet weak var newPromoCodeTextfield: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPromoCodeTextfield.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(promoCodeEntered(notification:)), name: NotificationIdentifier.promoCodeAdded, object: nil)
    }
    
    //call after user leaves the viewcontroller.
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationIdentifier.promoCodeAdded, object: nil)
    }
    
    
    @objc fileprivate func promoCodeEntered(notification: Notification) {
        if newPromoCodeTextfield.text == "" {
            applyButton.backgroundColor = UIColor.gray
        } else {
            applyButton.backgroundColor = UIColor.blue
        }
        
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        
        
    }
    
}

extension PromoCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            NotificationCenter.default.post(name: NotificationIdentifier.promoCodeAdded, object: nil)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NotificationCenter.default.post(name: NotificationIdentifier.promoCodeAdded, object: nil)
        return true
    }
    
}
