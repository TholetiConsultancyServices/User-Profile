//
//  LognService.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import ReachabilitySwift
import SwiftKeychainWrapper


class LoginService: LoginServiceProtocol {
    
    private let url = "\(baseURL)/session"
    
    var canAutoLogin: Bool {
        return (KeychainWrapper.standard.cachedCredentials != nil)
    }
    
    private let networkManager: NetworkManagerProtocol
    private(set) var session: Session?
    private(set) var userCredentials:UserCredentials?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    deinit {
        print("")
    }
    
    func autoLogin(completionHandler: @escaping (LoginResult) -> Void) {
        guard let credentials = KeychainWrapper.standard.cachedCredentials else {
            completionHandler(.Failure(.invalidCredentials))
            return
        }
        
        login(withEmail: credentials.email,
              password: credentials.password,
              completionHandler: completionHandler)
    }
    
    func login(withEmail: String,
               password: String,
               completionHandler: @escaping LoginCompletionHandler){
        
        let bodyJSONObject = RequestSession(email: withEmail, password: password).toJSON()
        networkManager.uploadTask(with: url, from: bodyJSONObject, requestHeaders: nil) { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .Success(let JSON):
                guard let session = Session(JSON: JSON) else {
                    completionHandler(.Failure(.dataError))
                    return
                }
                strongSelf.session = session
                strongSelf.userCredentials = UserCredentials(email: withEmail, password: password)
                KeychainWrapper.standard.saveUserCredentials(strongSelf.userCredentials!)
                completionHandler(.Success(session))
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }
    }
}
