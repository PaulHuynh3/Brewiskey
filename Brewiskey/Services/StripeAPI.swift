//
//  StripeAPI.swift
//  Brewiskey
//
//  Created by Paul on 2018-07-17.
//  Copyright © 2018 Paul. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class StripeAPI {
    
    func createNewCustomer() {
        let createCustomerUrl = URL(string:"https://api.stripe.com/v1/customers")
        let header = ["Authorization": SecretKeys.StripeLiveKey]
        
        Alamofire.request(createCustomerUrl!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            print(response)
        }
    }
    
}
