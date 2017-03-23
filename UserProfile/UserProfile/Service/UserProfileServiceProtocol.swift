//
//  UserProfileServiceProtocol.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import UIKit

enum DownloadUserProfileResult {
    case Success(UserProfile)
    case Failure(NetworkError)
}

enum DownloadAvatarResult {
    case Success(Avatar)
    case Failure(NetworkError)
}

typealias DownloadUserProfileCompletionHandler = (DownloadUserProfileResult)->Void
typealias UploadAvatarCompletionHandler = (DownloadAvatarResult)->Void


protocol UserProfileServiceProtocol {
    func dowloadUserProfile(completionHandler: @escaping DownloadUserProfileCompletionHandler)
    func uploadAvatar(avatar: UIImage, completionHandler: @escaping UploadAvatarCompletionHandler)
}
