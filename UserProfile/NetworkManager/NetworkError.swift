//
//  UPError.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation

enum NetworkError {
    case offline
    case dataError
    case invalidCredentials
    case urlError
    case networkRequestFailed
    case jsonSerializationFailed
    case jsonParsingFailed
}
