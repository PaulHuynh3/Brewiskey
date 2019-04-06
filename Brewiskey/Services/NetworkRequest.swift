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
    /*
    func request(urlComponent: String, requestType: String, postBody: Data?, success: @escaping (Data) -> Void, failed: @escaping (String?) -> Void) {

            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
            let url = URL(string: API_Keys.kBaseUrl + urlComponent)
            guard let link = url else {
                DispatchQueue.main.async {
                    failed("The link was nil")
                }
                return
            }
            var request = URLRequest(url: link, cachePolicy:.useProtocolCachePolicy, timeoutInterval: NetworkConstants.timeOut)
            
            request.addValue(NetworkConstants.applicationJson, forHTTPHeaderField: NetworkConstants.contentType)
            request.addValue(NetworkConstants.applicationJson, forHTTPHeaderField: NetworkConstants.accept)
            request.httpMethod = requestType
            request.httpBody = postBody
            
            let dataTask = session.dataTask(with: request) { (data:Data?, urlResponse:URLResponse?, error:Error?) in
                if let error = error {
                    DispatchQueue.main.async {
                        failed(error.localizedDescription)
                    }
                    return
                }
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        DispatchQueue.main.async {
                            failed("Error status code:\(httpResponse.statusCode)")
                        }
                        return
                    }
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        failed("Data is nil")
                    }
                    return
                }
                DispatchQueue.main.async {
                    success(data)
                }
            }
            dataTask.resume()
    }
 */
}


