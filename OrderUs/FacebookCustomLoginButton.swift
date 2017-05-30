//
//  FacebookCustomLoginButton.swift
//  OrderUs
//
//  Created by Muhammadali on 30/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol FacebookCustomLoginButtonDelegate {
    func facebookCustomloginButton(_ loginButton: FacebookCustomLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    func facebookCustomloginButtonWillLogin(_ loginButton: FacebookCustomLoginButton!) -> Bool
}

class FacebookCustomLoginButton: UIButton {

    var delegate: FacebookCustomLoginButtonDelegate?

}
