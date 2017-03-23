//
//  LoginServiceProtocol.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation


enum LoginResult {
    case Success(Session)
    case Failure(NetworkError)
}

typealias LoginCompletionHandler = (LoginResult)->Void

protocol LoginServiceProtocol {
    
    var userCredentials: UserCredentials? { get }
    var session:Session? { get }
    var canAutoLogin: Bool { get }
    func autoLogin(completionHandler:@escaping LoginCompletionHandler)
    func login(withEmail: String,
               password: String,
               completionHandler:@escaping LoginCompletionHandler)
}
