//
//  Extensions.swift
//  Brewiskey
//
//  Created by Paul on 2018-02-25.
//  Copyright © 2018 Paul. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    //So that the downloaded images dont need to be downloaded again. Saves networking data.
    func loadImagesUsingCacheWithUrlString(urlString: String){
        
        //blank out white space to take out flashing.
        self.image = nil
        //set image if its there
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
            self.image = cachedImage
            return
        }
        
        //if not then dl the image.
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let error = error {
                print(error, #line)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            }
        })
        task.resume()
        
    }
}

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
}

extension UIColor {
    
    struct brewiskeyColours {
        static let lightGray = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)
    }
    
}
