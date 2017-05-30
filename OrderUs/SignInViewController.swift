//
//  SignInViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 30/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

protocol SignInViewControllerDelegate {
    func signInCompleted()
}

class SignInViewController: UIViewController, SignInModelDelegate, GIDSignInUIDelegate {
    
    var delegate: SignInViewControllerDelegate?
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var facebookCustomLoginViewOutlet: UIView!
    @IBOutlet weak var facebookCustomLoginButtonOutlet: FacebookCustomLoginButton!
    
    @IBOutlet weak var googleCustomLoginButtonOutlet: UIButton!
    @IBOutlet weak var googleCustomLoginViewOutlet: UIView!
    
    @IBOutlet weak var alternateOptionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInModel.sharedInstance.delegate = self
        [(emailOutlet, "Email Address"), (passwordOutlet, "Password")].forEach { (textField, placeholderText) in
            textField?.layer.borderWidth = 2
            textField?.layer.borderColor = UIColor.white.cgColor
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSForegroundColorAttributeName: UIColor.orange]
            )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFacebookLoginButton()
        setupGoogleLoginButton()
        SignInModel.sharedInstance.signInViewDidLoad()
        if (!SignInModel.sharedInstance.signedIn && !signInInProgress) {
            facebookCustomLoginButtonOutlet.isHidden = false
            googleCustomLoginButtonOutlet.isHidden = false
        }
    }
    
    
    @IBAction func facebookCustomLoginButtonAction(_ sender: FacebookCustomLoginButton) {
        if (facebookCustomLoginButtonOutlet.delegate?.facebookCustomloginButtonWillLogin(facebookCustomLoginButtonOutlet)) ?? false {
            FBSDKLoginManager().logIn(
                withReadPermissions: ["public_profile", "email", "user_friends"],
                from: self
            ) { [unowned uoSelf = self] (result, error) in
                if (error != nil || (result?.isCancelled ?? false)) {
                    uoSelf.showUI()
                    uoSelf.spinner.stopAnimating()
                    return
                }
                uoSelf.facebookCustomLoginButtonOutlet.setTitle("Log out", for: .normal)
                uoSelf.facebookCustomLoginButtonOutlet.delegate?.facebookCustomloginButton(uoSelf.facebookCustomLoginButtonOutlet, didCompleteWith: result, error: error)
            }
        }
    }
    
    private func setupFacebookLoginButton() {
        facebookCustomLoginButtonOutlet.delegate = SignInModel.sharedInstance
    }
    
    private func setupGoogleLoginButton() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = SignInModel.sharedInstance
        
    }
    
    @IBAction func googleCustomLoginButtonAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        signInStarted()
        print("function 1 was called")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        print("function 2 was called")
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        googleCustomLoginButtonOutlet.setTitle("Log Out", for: .normal)
        print("function 3 was called")
    }
    
    
    var signInInProgress = false
    
    private func hideUI() {
        let duration = 1.0
        UIView.animate(
            withDuration: duration) { [unowned uoSelf = self] in
                uoSelf.emailOutlet.alpha = 0
                uoSelf.passwordOutlet.alpha = 0
                uoSelf.facebookCustomLoginViewOutlet.alpha = 0
                uoSelf.googleCustomLoginViewOutlet.alpha = 0
                uoSelf.alternateOptionsLabel.alpha = 0
        }
    }
 
    private func showUI() {
        let duration = 1.0
        UIView.animate(
        withDuration: duration) { [unowned uoSelf = self] in
            uoSelf.emailOutlet.alpha = 1
            uoSelf.passwordOutlet.alpha = 1
            uoSelf.facebookCustomLoginViewOutlet.alpha = 1
            uoSelf.googleCustomLoginViewOutlet.alpha = 1
            uoSelf.alternateOptionsLabel.alpha = 1
        }
    }
    
    func signInStarted() {
        spinner.startAnimating()
        signInInProgress = true
        hideUI()
    }
    
    func signInCompleted() {
        signInInProgress = false
        spinner.stopAnimating()
        delegate?.signInCompleted()
    }
    
}
