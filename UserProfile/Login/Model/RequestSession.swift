//
//  RequestSession.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct RequestSession: Mappable {
    private var email: String?
    private var password: String?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        email  <- map["email"]
        password  <- map["password"]
    }
}

