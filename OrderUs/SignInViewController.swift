//
//  ViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-02-24.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SignInViewController: UIViewController, GIDSignInUIDelegate, SignInModelDelegate {
    
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    
    @IBAction func signInButton(_ sender: UIButton) {
        if (loadingCircle.isAnimating) {
            loadingCircle.stopAnimating()
        } else {
            loadingCircle.startAnimating()
        }
    }
    
    @IBOutlet weak var facebookLoginButtonOutlet: FBSDKLoginButton!
    private func setupFacebookLoginButton() {
        facebookLoginButtonOutlet.delegate = SignInModel.sharedInstance
        facebookLoginButtonOutlet.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButtonOutlet.sizeToFit()
    }
    
    
    @IBOutlet weak var googleLoginButtonOutlet: GIDSignInButton!
    private func setupGoogleLoginButton() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = SignInModel.sharedInstance
        googleLoginButtonOutlet.style = .standard
        googleLoginButtonOutlet.backgroundColor = UIColor.white
        googleLoginButtonOutlet.sizeToFit()
    }
    
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        signInStarted()
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
    
    var signInInProgress = false
    func signInStarted() {
        loadingCircle.startAnimating()
        signInInProgress = true
        let duration = 1.0
        
        UIView.transition(
            with: facebookLoginButtonOutlet,
            duration: duration,
            options: [.curveEaseInOut, .transitionCrossDissolve],
            animations: { [unowned uoSelf = self] in
                uoSelf.facebookLoginButtonOutlet.isHidden = true
        }, completion: nil)
        
        UIView.transition(
            with: googleLoginButtonOutlet,
            duration: duration,
            options: [.curveEaseInOut, .transitionCrossDissolve],
            animations: { [unowned uoSelf = self] in
                uoSelf.googleLoginButtonOutlet.isHidden = true
            }, completion: nil)
    }
    
    func signInCompleted() {
        signInInProgress = false
        loadingCircle.stopAnimating()
        performSegue(withIdentifier: "MainMenu", sender: nil)
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInModel.sharedInstance.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupFacebookLoginButton()
        setupGoogleLoginButton()
        SignInModel.sharedInstance.signInViewDidLoad()
        if (!SignInModel.sharedInstance.signedIn && !signInInProgress) {
            facebookLoginButtonOutlet.isHidden = false
            googleLoginButtonOutlet.isHidden = false
        }
    }
    
}

