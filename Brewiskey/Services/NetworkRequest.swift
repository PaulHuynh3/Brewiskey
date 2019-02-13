//
//  NetworkRequest.swift
//  Brewiskey
//
//  Created by Paul on 2019-02-13.
//  Copyright © 2019 Paul. All rights reserved.
//

import UIKit

class NetworkRequest {
    func loadImageFromUrl(urlString: String, completion: @escaping (UIImage?, String?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            guard let data = data else {
                let errorMessage = "Load image data found nil"
                completion(nil, errorMessage)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    completion(downloadedImage, nil)
                }
            }
        }
        task.resume()
    }
}


