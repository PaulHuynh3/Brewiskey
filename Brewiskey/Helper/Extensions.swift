//
//  Extensions.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func trim() -> String{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

extension UIViewController {
   
    func showAlert(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithAction(title: String, message: String, actionTitle: String, cancelTitle: String,  completion: @escaping (()->())) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let preferredAction = UIAlertAction(title: actionTitle, style: .default) { (action: UIAlertAction) in
            DispatchQueue.main.async {
                completion()
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alert.addAction(preferredAction)
        alert.addAction(cancelAction)
        alert.preferredAction = preferredAction
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Initialize a view controller. The storuyboard name and the identifier are option.
     If the identifier is missing, it is assuming it is the same as the name of the class.
     */
    class func fromStoryboard<T : UIViewController>(name storyboardName: String, withIdentifier identifier:String = "") -> T {
        var controllerIdentifier = identifier
        if controllerIdentifier == "" {
            controllerIdentifier = String(describing: self)
        }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: controllerIdentifier) as! T
    }
    
}

extension UIColor {
    
    struct brewiskeyColours {
        static let lightGray = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
    }
    
}
