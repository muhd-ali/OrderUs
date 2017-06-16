//
//  MainMenuViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-05-03.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import FBSDKLoginKit
import GoogleSignIn

class MainMenuViewController: UITabBarController {
    struct Constants {
        static let appTintColor = UIColor(red: 244/255, green: 124/255, blue: 32/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Constants.appTintColor
    }
}
