//
//  UserProfilePresenter.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import UIKit


struct FetchUserProfileInfoError{
    static let serverError   = "The server is not working."
    static let networkError  = "The network appears to be down."
    static let dataError     = "We're having trouble processing profile data."
    static let uploadPhotoError   = "We're having trouble uploading profile photo."
}

struct UploadProfilePhotoError{
    static let uploadPhotoError   = "We're having trouble uploading profile photo."
}


enum FetchUserProfileInfoResult {
    case Success(UserProfileViewModel)
    case Failure(String)
}

enum UploadProfilePhotoResult {
    case Success
    case Failure(String)
}

typealias FetchUserProfileCompletionHandler = (FetchUserProfileInfoResult)->Void
typealias UploadProfilePhotoCompletionHandler = (UploadProfilePhotoResult)->Void

class UserProfilePresenter {
    
    private let userProfileService: UserProfileServiceProtocol
    private let userCredentials: UserCredentials?
    init(service: UserProfileServiceProtocol, userCredentials: UserCredentials?) {
        self.userProfileService = service
        self.userCredentials = userCredentials
    }
    
    func uploadProfilePhoto(photo: UIImage,
                            uploadProfilePhotoCompletionHandler: @escaping UploadProfilePhotoCompletionHandler) {
        userProfileService.uploadAvatar(avatar: photo,
                                         completionHandler: { [weak self] (result) in
                                            
                                            DispatchQueue.main.async {
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                
                                                switch result {
                                                case .Success(_):
                                                    uploadProfilePhotoCompletionHandler(.Success)
                                                case .Failure(let error):
                                                    let errorDescripton = strongSelf.errorDescription(for: error)
                                                    uploadProfilePhotoCompletionHandler(.Failure(errorDescripton))
                                                }
                                            }
        })

    }
    
    func fetchUserProfile(fetchUserProfileCompletionHandler: @escaping FetchUserProfileCompletionHandler) {
        userProfileService.dowloadUserProfile(completionHandler: {[weak self] (result) in
            DispatchQueue.main.async {
                
                guard let strongSelf = self else {
                    return
                }

                switch result {
                case .Success(let profile):
                    var profilePhoto: UIImage?
                    if profile.avatar != nil {
                        guard let encodedStringImageData = profile.avatar,
                            let profileImageData = Data(base64Encoded: encodedStringImageData) else {
                                fetchUserProfileCompletionHandler(.Failure(FetchUserProfileInfoError.dataError))
                                return
                        }
                        
                        profilePhoto = UIImage(data: profileImageData)
                    } else {
                        profilePhoto = UIImage(named: "profile_placeholder")
                    }
                    let viewModel = UserProfileViewModel(email: (strongSelf.userCredentials?.email)!,
                                                         password: (strongSelf.userCredentials?.password)!,
                                                         profilePhoto: profilePhoto)
                    
                    fetchUserProfileCompletionHandler(.Success(viewModel))
                    
                case .Failure(_):
                    fetchUserProfileCompletionHandler(.Failure(UploadProfilePhotoError.uploadPhotoError))
                    break;
                }
            }
        })
    }
    
    private func errorDescription(for error:NetworkError) -> String {
        var errorDescripton:String = String()
        switch error {
            case .urlError: errorDescripton = FetchUserProfileInfoError.serverError
            case .networkRequestFailed, .offline: errorDescripton = FetchUserProfileInfoError.networkError
            case .jsonSerializationFailed, .jsonParsingFailed: errorDescripton = FetchUserProfileInfoError.dataError
            case .dataError: errorDescripton = FetchUserProfileInfoError.dataError
            default: break
        }
        return errorDescripton
    }
}
