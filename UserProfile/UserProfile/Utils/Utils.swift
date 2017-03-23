//
//  Utils.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func viewController(storyboardName:String,identifier:String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard .instantiateViewController(withIdentifier: identifier)
    }
}

