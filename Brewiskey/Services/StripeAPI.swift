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
    
   var stripeCustomerBaseUrl = URL(string: "https://api.stripe.com/v1/customers")
   let authorizationHeader = ["Authorization": SecretKeys.StripeLiveKey]
    
    func createCustomer(email: String, completion:@escaping (_ stripeCustomerID: String?, _ error: String?) -> Void)  {
        let params: [String: Any] = [
            "email": email
        ]
        
        Alamofire.request(stripeCustomerBaseUrl!, method: .post, parameters: params, encoding: URLEncoding.default, headers: authorizationHeader).validate(statusCode: 200..<300).responseJSON{ (response) in
            if let error = response.result.error  {
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                    print(error)
                    return
                }
            }
            if let customerJSON = response.result.value {
                DispatchQueue.main.async {
                  
                    let customerObject = customerJSON as! Dictionary <String, Any>
                    let customerId = customerObject["id"] as? String
                  
                    completion(customerId, nil)
                }
            }
        }
    }
    
    func retrieveCustomer(customerId: String, completion:@escaping (_ stripeCustomer: StripeCustomer?, _ error: String?) -> Void) {
        
        guard let retrieveCustomerUrl = stripeCustomerBaseUrl?.appendingPathComponent(customerId) else {return}
        
        Alamofire.request(retrieveCustomerUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authorizationHeader).validate(statusCode: 200..<300).responseJSON{ (response) in
            if let error = response.result.error  {
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                    print(error)
                    return
                }
            }
            if let customerJSON = response.result.value {
                DispatchQueue.main.async {
                    let stripeCustomer = StripeCustomer()
                    let customerObject = customerJSON as! Dictionary <String, Any>
                    stripeCustomer.customerId = customerObject["id"] as? String
                    stripeCustomer.email = customerObject["email"] as? String
                    completion(stripeCustomer, nil)
                }
            }
        }
    }
    //stripe should update automatically tho..
    func updateExistingCustomer(customerId: String, email: String, description: String, completion:@escaping (_ stripeCustomer: StripeCustomer?, _ error: String?) -> Void) {
        let params: [String: Any] = [
            "email": email,
            "description": description
        ]
        
        Alamofire.request(stripeCustomerBaseUrl!, method: .post, parameters: params, encoding: URLEncoding.default, headers: authorizationHeader).validate(statusCode: 200..<300).responseJSON{ (response) in
            if let error = response.result.error  {
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                    print(error)
                    return
                }
            }
            if let customerJSON = response.result.value {
                DispatchQueue.main.async {
                    let stripeCustomer = StripeCustomer()
                    let customerObject = customerJSON as! Dictionary <String, Any>
                    stripeCustomer.customerId = customerObject["id"] as? String
                    stripeCustomer.email = customerObject["email"] as? String
                    //set stripe customer description = etc..
                    completion(stripeCustomer, nil)
                }
            }
        }
    }
}
