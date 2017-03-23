//
//  MockNetworkManager.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 23/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation

@testable import UserProfile

class MockNetworkManager: NetworkManagerProtocol {
    
    func uploadTask(with url: String,
                    from JSONObject: Any,
                    requestHeaders:[String: String]?,
                    completionHandler:@escaping NetworkCompletionHandler) {
        DispatchQueue.main.async {
            guard let sessionJSON = TestUtils().loadJSONData(fromFileName: "test_session") else {
                completionHandler(.Failure(.dataError))
                return
            }
            completionHandler(.Success(sessionJSON))
        }
    }
    
    func dowloadTask(with url: String,
                     requestHeaders:[String: String]?,
                     completionHandler:@escaping NetworkCompletionHandler) {
        
    }
}
