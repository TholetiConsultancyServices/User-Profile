//
//  KeychainWrapperUtils.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 23/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import SwiftKeychainWrapper

private let emailKeyChainKey = "emailKey"
private let passwordKeyChainKey = "passwordKey"

extension KeychainWrapper {
    
    var cachedCredentials: UserCredentials? {
        //  return nil
        guard let email = KeychainWrapper.standard.string(forKey: emailKeyChainKey),
            let password = KeychainWrapper.standard.string(forKey: passwordKeyChainKey) else {
                return nil
        }
        return UserCredentials(email: email, password: password)
    }
    
    func saveUserCredentials(_ credentials: UserCredentials) {
        KeychainWrapper.standard.set(credentials.email, forKey: emailKeyChainKey)
        KeychainWrapper.standard.set(credentials.password, forKey: passwordKeyChainKey)
    }
    func deleteUserCredentials() {
        KeychainWrapper.standard.removeObject(forKey: emailKeyChainKey)
        KeychainWrapper.standard.removeObject(forKey: passwordKeyChainKey)
    }
}
