//
//  NetworkManager.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import ReachabilitySwift
import ObjectMapper


enum NetworkResult{
    case Success([String: Any])
    case Failure(NetworkError)
}

typealias NetworkCompletionHandler = (NetworkResult)->Void

protocol NetworkManagerProtocol {
    func uploadTask(with url: String,
                    from JSONObject: Any,
                    requestHeaders:[String: String]?,
                    completionHandler:@escaping NetworkCompletionHandler)
    
    func dowloadTask(with url: String,
                     requestHeaders:[String: String]?,
                     completionHandler:@escaping NetworkCompletionHandler)
}

struct NetworkManager: NetworkManagerProtocol {
    
    func uploadTask(with url: String,
                    from JSONObject: Any,
                    requestHeaders:[String: String]?,
                    completionHandler:@escaping NetworkCompletionHandler) {
        
        let reachability = Reachability()
        guard reachability?.isReachable == true else {
            completionHandler(.Failure(.offline))
            return
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
    
        if let headers = requestHeaders {
            for (header,value) in headers {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        var JSONData: Data?
        if JSONSerialization.isValidJSONObject(JSONObject) {
            do {
                JSONData = try JSONSerialization.data(withJSONObject: JSONObject, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch let error {
                print(error)
                JSONData = nil
            }
        }
        let task = URLSession.shared.uploadTask(with: request, from: JSONData) { data, response, error in
            self.processResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }
        
        task.resume()
    }
    
    func dowloadTask(with url: String,
                     requestHeaders:[String: String]?,
                     completionHandler:@escaping NetworkCompletionHandler) {
        let reachability = Reachability()
        guard reachability?.isReachable == true else {
            completionHandler(.Failure(.offline))
            return
        }
    
        var request = URLRequest(url: URL(string: url)!)
        if let headers = requestHeaders {
            for (header,value) in headers {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.processResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }
        
        task.resume()
    }

    private func processResponse(data: Data?,
                                 response: URLResponse?,
                                 error: Error?,
                                 completionHandler: NetworkCompletionHandler) {
        
        // Check network error
        guard error == nil else {
            completionHandler(.Failure(.networkRequestFailed))
            return
        }
        
        // Check JSON serialization error
        guard let unwrappedData = data else {
            completionHandler(.Failure(.jsonSerializationFailed))
            return
        }
        
        do {
            if let JSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any] {
                completionHandler(.Success(JSON))
            }
        } catch {
            completionHandler(.Failure(.jsonSerializationFailed))
        }
    }
    
}
