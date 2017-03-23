//
//  AppManager.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper


class AppManager {
    
    private var window:UIWindow?
    private var loginService: LoginServiceProtocol
    private var networkManager = NetworkManager()
  
    static let shareInstance = AppManager()

    private init() {
        self.loginService = LoginService(networkManager: networkManager)
    }
    
    func prepareAppContentWithWindow(window:UIWindow?){
        self.window = window
        if loginService.canAutoLogin == true {
            window?.rootViewController = loadingViewController
            loginService.autoLogin {[weak self] (result) in
                
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    switch result {
                    case .Success(_):
                        strongSelf.showUserProfileScreen()
                    case .Failure(_):
                        strongSelf.showLoginScreen()
                    }
                }
            }
        } else {
            showLoginScreen()
         }
    }
    
    func logout() {
        KeychainWrapper.standard.deleteUserCredentials()
        showLoginScreen()
    }
    
    private func showUserProfileScreen() {
        let userProfileNavigationVC = userProfileViewNavigationController
        self.window?.rootViewController = userProfileNavigationVC
        guard let userProfileVC = userProfileNavigationVC.topViewController as? UserProfileViewController else {
            return
        }
        
        let userProfileService = UserProfileService(session: loginService.session, networkManager: networkManager)
        let userCredentials = loginService.userCredentials
        let presenter = UserProfilePresenter(service: userProfileService, userCredentials: userCredentials)
        userProfileVC.presenter = presenter
    }
    
    
    
    private func showLoginScreen() {
        
        let loginNavigationVC = loginNavigationController
        self.window?.rootViewController = loginNavigationVC
        guard let loginViewController = loginNavigationVC.topViewController as? LoginViewController else {
            return
        }
        loginViewController.loginService = loginService
        loginViewController.loginCompletionHandler = {
            self.showUserProfileScreen()
        }
    }
    
    private var loginNavigationController: UINavigationController {
        return UIStoryboard.viewController(storyboardName: "Main",
                                           identifier: "LoginNavigationController") as! UINavigationController
    }
    
    private var loadingViewController: LoadingViewController {
        return UIStoryboard.viewController(storyboardName: "Main",
                                           identifier: "LoadingViewController") as! LoadingViewController
    }
    
    private var userProfileViewNavigationController: UINavigationController {
        return UIStoryboard.viewController(storyboardName: "Main",
                                           identifier: "UserProfileNavigationController") as! UINavigationController
    }
}
