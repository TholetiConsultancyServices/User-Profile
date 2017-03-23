//
//  Avatar.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Avatar: Mappable {
    private(set) var avatar: String?
    
    init?(map: Map) { }
    
    init(avatar: String) {
        self.avatar = avatar
    }
    
    mutating func mapping(map: Map) {
        avatar  <- map["avatar"]
    }
}
