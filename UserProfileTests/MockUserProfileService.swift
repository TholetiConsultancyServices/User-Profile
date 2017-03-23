//
//  MockUserProfileService.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import UIKit

@testable import UserProfile

class MockUserProfileService: UserProfileServiceProtocol {
    func dowloadUserProfile(completionHandler: @escaping DownloadUserProfileCompletionHandler) {
        
        DispatchQueue.main.async {
            guard let profileJSON = TestUtils().loadJSONData(fromFileName: "user_profile") else {
                completionHandler(DownloadUserProfileResult.Failure(.urlError))
                return
            }
            let profile = UserProfile(JSON: profileJSON)
            completionHandler(.Success(profile!))
        }
        
    }
    func uploadAvatar(avatar: UIImage, completionHandler: @escaping UploadAvatarCompletionHandler) {
        DispatchQueue.main.async {
            guard let avatarJSON = TestUtils().loadJSONData(fromFileName: "test_avatar") else {
                completionHandler(.Failure(.urlError))
                return
            }
            let avatar = Avatar(JSON: avatarJSON)
            completionHandler(.Success(avatar!))
        }
        
    }
}
