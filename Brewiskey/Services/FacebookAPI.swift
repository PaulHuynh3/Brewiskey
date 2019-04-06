//
//  FacebookAPI.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-06.
//  Copyright © 2018 Paul. All rights reserved.

import Foundation
import FBSDKLoginKit

class FacebookAPI: NSObject {
    
    class func userFacebookData(completion: @escaping (Dictionary<String, Any>)->Void) {
        if FBSDKAccessToken.current() != nil {
            let graphPath = "me"
            let fields = "fields"
            let parameters = "id, name, first_name, last_name, picture.type(large), email"
            
            let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: [fields: parameters])
            guard let request = graphRequest else {return}
            
            request.start(completionHandler: { (connection, result, error) in
                guard let data = result as? Dictionary<String, Any> else {return}
                
                if let error = error {
                    print(error)
                    return
                }
                completion(data)
            })
        }
    }
    
}
