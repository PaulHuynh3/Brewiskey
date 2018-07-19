//
//  UserDefaultsUtils.swift
//  Brewiskey
//
//  Created by Paul on 2018-04-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation

class UserDefaultsUtils {
    
    func deleteAllUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
