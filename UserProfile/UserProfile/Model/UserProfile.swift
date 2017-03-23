//
//  UserProfile.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserProfile: Mappable {
    private(set) var email: String?
    private(set) var avatar: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        email  <- map["email"]
        avatar  <- map["avatar"]
    }
}
