//
//  SignInModel.swift
//  OrderUs
//
//  Created by Muhammadali on 03/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import FacebookLogin
import GoogleSignIn

class SignInModel: NSObject, LoginButtonDelegate, GIDSignInDelegate {
    
    static let sharedInstance = SignInModel()
    
    // Facebook Login Button Delegate API
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("======================Logged in Using Facebook========================")
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("======================Logged out of Facebook========================")
    }
    
    // Google Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            print("======================Logged in Using Google========================")
        } else {
            print("\(error.localizedDescription)")
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("======================Logged out of Google========================")
    }
}
