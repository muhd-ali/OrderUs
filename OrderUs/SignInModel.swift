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


protocol SignInModelDelegate {
    func signInStarted()
    func signInFailed()
    func signInCompleted()
}

struct UserData {
    let id: String?
    let name: String?
    let email: String?
    var jsonData: [String:Any] {
        return [
            "id" : id ?? "",
            "name" : name ?? "",
            "email" : email ?? "",
        ]
    }
    static let null = UserData(id: nil, name: nil, email: nil)
}

class SignInModel: NSObject, FacebookCustomLoginButtonDelegate, GIDSignInDelegate {
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
    func facebookCustomloginButton(_ loginButton: FacebookCustomLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if (error == nil && !result.isCancelled) {
            print("======================Logged in Using Facebook========================")
            userSignedInSoGetFacebookUserInfo()
            delegate?.signInCompleted()
        } else {
            delegate?.signInFailed()
        }
    }
    
    func facebookCustomloginButtonWillLogin(_ loginButton: FacebookCustomLoginButton!) -> Bool {
        delegate?.signInStarted()
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FacebookCustomLoginButton!) {
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
            delegate?.signInFailed()
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("======================Logged out of Google========================")
    }
}
