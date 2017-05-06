//
//  ViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-02-24.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    
    @IBAction func signInButton(_ sender: UIButton) {
        if (loadingCircle.isAnimating) {
            loadingCircle.stopAnimating()
        } else {
            loadingCircle.startAnimating()
        }
    }
    
    internal func setupFacebookLoginButton() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.bounds.origin.y  = loginButton.bounds.origin.y - 50
        loginButton.delegate = SignInModel.sharedInstance
        view.addSubview(loginButton)
    }
    
    internal func setupGoogleLoginButton() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = SignInModel.sharedInstance
        
        let loginButton = GIDSignInButton()
        loginButton.backgroundColor = UIColor.white
        loginButton.center = view.center
        loginButton.bounds.origin.y  = loginButton.bounds.origin.y - 100
        view.addSubview(loginButton)
    }
    
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //        myActivityIndicator.stopAnimating()
        print("function 1 was called")
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        print("function 2 was called")
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        print("function 3 was called")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFacebookLoginButton()
        setupGoogleLoginButton()
    }
    
}

