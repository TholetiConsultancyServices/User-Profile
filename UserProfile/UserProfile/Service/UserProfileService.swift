//
//  UserProfileService.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import UIKit

struct UserProfileService: UserProfileServiceProtocol {
    
    private let baseUrl = "\(baseURL)/users"
    private let session: Session?
    private let networkManager: NetworkManagerProtocol
    
    init(session: Session?, networkManager: NetworkManagerProtocol) {
        self.session = session
        self.networkManager = networkManager
    }
    
    func dowloadUserProfile(completionHandler: @escaping DownloadUserProfileCompletionHandler) {
        
        guard let userid = session?.userid else {
            completionHandler(.Failure(.urlError))
            return
        }
        
        let url = "\(baseUrl)/\(userid)"
        networkManager.dowloadTask(with: url, requestHeaders: requestHeaders) { (result) in
            switch result {
            case .Success(let JSON):
                guard  let userProfile = UserProfile(JSON: JSON) else {
                    completionHandler(.Failure(.dataError))
                    return
                }
                completionHandler(.Success(userProfile))
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }

    }
    
    func uploadAvatar(avatar: UIImage, completionHandler: @escaping UploadAvatarCompletionHandler) {
        guard let userid = session?.userid else {
            completionHandler(.Failure(.urlError))
            return
        }
        
        let url = "\(baseUrl)/\(userid)/avatar"
        guard let encodedImageString = UIImagePNGRepresentation(avatar)?.base64EncodedString() else {
            completionHandler(.Failure(.dataError))
            return
        }
        
        let bodyJSONObject = ["avatar" : encodedImageString]
        networkManager.uploadTask(with: url, from: bodyJSONObject, requestHeaders: requestHeaders) { (result) in
            switch result {
            case .Success(let JSON):
                guard let avatar = Avatar(JSON: JSON) else {
                    completionHandler(.Failure(.dataError))
                    return
                }
                completionHandler(.Success(avatar))
            case .Failure(let error):
                completionHandler(.Failure(error))
            }
        }
    }
    
    private var requestHeaders: [String: String]? {
        guard let token = session?.token else {
            return nil
        }
        return ["Authorization":"Bearer \(token)"]
    }
}
