//
//  UpdateCartUtils.swift
//  Brewiskey
//
//  Created by Paul on 2018-09-02.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit

class UpdateCartUtils {
    
    class func getAppDelegateInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func updateItemsForCart(items: Int) {
        let tabBarController = UpdateCartUtils.getAppDelegateInstance().window?.rootViewController?.children.last?.tabBarController
        guard let tabBarItem = tabBarController?.tabBar.items![1] else {return}
        tabBarItem.badgeColor = UIColor(red:0.36, green:0.36, blue:0.36, alpha:1)
        tabBarItem.badgeValue = String(items)
    }
    
    func deleteCartItems() {
        let tabBarController = UpdateCartUtils.getAppDelegateInstance().window?.rootViewController?.children.last?.tabBarController
        guard let tabBarItem = tabBarController?.tabBar.items![1] else {return}
        tabBarItem.badgeValue = nil
    }

}
