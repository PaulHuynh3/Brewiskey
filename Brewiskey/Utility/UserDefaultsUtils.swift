//
//  UserDefaultsUtils.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation

class UserDefaultsUtils {
    
    func clearUserDefaults(){
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: kUserInfo.kLoginStatus)
        userDefault.set(nil, forKey: kUserInfo.kUserId)
        userDefault.set(nil, forKey: kUserInfo.kEmail)
        userDefault.set(nil, forKey: kUserInfo.kFirstName)
        userDefault.set(nil, forKey: kUserInfo.kLastName)
        userDefault.set(false, forKey: kUserInfo.kNewUser)
        userDefault.set(nil, forKey: kUserInfo.kCheckoutOrderQuantity)
        userDefault.set(nil, forKey: kUserInfo.kOrderNumber)
    }
    
    func deleteAllUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    

}
