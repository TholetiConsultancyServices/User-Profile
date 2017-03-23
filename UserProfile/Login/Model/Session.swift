//
//  Session.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Session: Mappable {
    private(set) var userid: Int?
    private(set) var token: String?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        userid  <- map["userid"]
        token  <- map["token"]
    }
}
