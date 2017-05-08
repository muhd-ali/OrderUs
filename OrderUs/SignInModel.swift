//
//  SignInModel.swift
//  OrderUs
//
//  Created by Muhammadali on 03/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import GoogleSignIn
import FacebookCore
//
//protocol SignInModelDelegate {
//    func signedIn()
//}
protocol SignInModelDelegate {
    func signInStarted()
    func signInCompleted()
}

struct UserData {
    let id: String?
    let name: String?
    let email: String?
}

class SignInModel: NSObject, FBSDKLoginButtonDelegate, GIDSignInDelegate {
    var signedIn = false
    func signInViewDidLoad() {
        if (FBSDKAccessToken.current() != nil) {    // User already Signed Into Facebook
            delegate?.signInStarted()
            userSignedInSoGetFacebookUserInfo()
            delegate?.signInCompleted()
        } else if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {     // User already Signed Into Google
            delegate?.signInStarted()
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    private func userSignedInSoGetFacebookUserInfo() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { [unowned uoSelf = self] (response, result) in
            switch result {
            case .success(let value):
                let dict = value.dictionaryValue ?? [:]
                let id = dict["id"] as? String
                let fullname = dict["name"] as? String
                let email = dict["email"] as? String
                uoSelf.userData = UserData(
                    id: id,
                    name: fullname,
                    email: email
                )
                uoSelf.signedIn = true
            case .failed(let error):
                print(error)
            }
        }
    }
    
    private func userSignedInSoGetGoogleUserInfo(user: GIDGoogleUser) {
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let email = user.profile.email
        userData = UserData(
            id: idToken,
            name: fullName,
            email: email
        )
        signedIn = true
    }
    
    static let sharedInstance = SignInModel()
    var delegate: SignInModelDelegate?
    var userData: UserData?
    
    // Facebook Login Button Delegate API
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //
        guard (error == nil && !result.isCancelled) else {
            print("======================Could not log in Using Facebook========================")
            return
        }
        
        userSignedInSoGetFacebookUserInfo()
        print("======================Logged in Using Facebook========================")
        delegate?.signInCompleted()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        delegate?.signInStarted()
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("======================Logged out of Facebook========================")
    }
    
    // Google Delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            // Perform any operations on signed in user here.
            //            let userId = user.userID                  // For client-side use only!
            print("======================Logged in Using Google========================")
            userSignedInSoGetGoogleUserInfo(user: user)
            delegate?.signInCompleted()
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
