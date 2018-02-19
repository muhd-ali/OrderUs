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
    
    private struct ButtonText {
        static let signIn = "Log In"
        static let signOut = "Log Out"
    }
    
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
        setButtonsTextToSignIn()
        SignInModel.sharedInstance.delegate = self
        [(emailOutlet, "Email Address"), (passwordOutlet, "Password")].forEach { (textField, placeholderText) in
            textField?.layer.borderWidth = 2
            textField?.layer.borderColor = UIColor.white.cgColor
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange]
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
                uoSelf.facebookCustomLoginButtonOutlet.setTitle(ButtonText.signOut, for: .normal)
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
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        googleCustomLoginButtonOutlet.setTitle(ButtonText.signOut, for: .normal)
    }
    
    
    private var signInInProgress = false
    
    private func hideUI() {
        emailOutlet.alpha = 0
        passwordOutlet.alpha = 0
        facebookCustomLoginViewOutlet.alpha = 0
        googleCustomLoginViewOutlet.alpha = 0
        alternateOptionsLabel.alpha = 0
    }
    
    private func hideUI(animate: Bool) {
        if animate {
            let duration = 1.0
            UIView.animate(
            withDuration: duration) { [unowned uoSelf = self] in
                uoSelf.hideUI()
            }
        } else {
            hideUI()
        }
    }
    
    private func showUI() {
        emailOutlet.alpha = 1
        passwordOutlet.alpha = 1
        facebookCustomLoginViewOutlet.alpha = 1
        googleCustomLoginViewOutlet.alpha = 1
        alternateOptionsLabel.alpha = 1
    }

    private func showUI(animate: Bool) {
        if animate {
            let duration = 1.0
            UIView.animate(
            withDuration: duration) { [unowned uoSelf = self] in
                uoSelf.showUI()
            }
        } else {
            showUI()
        }
    }
    
    func signInStarted() {
        spinner.startAnimating()
        signInInProgress = true
        hideUI(animate: true)
    }
    
    func signInFailed() {
        spinner.stopAnimating()
        signInInProgress = false
        signedOut()
    }
    
    func signInCompleted() {
        signInInProgress = false
        spinner.stopAnimating()
        delegate?.signInCompleted()
    }
    
    private func setButtonsTextToSignIn() {
        googleCustomLoginButtonOutlet.setTitle(ButtonText.signIn, for: .normal)
        facebookCustomLoginButtonOutlet.setTitle(ButtonText.signIn, for: .normal)
    }
    
    func signedOut() {
        showUI(animate: true)
        setButtonsTextToSignIn()
    }
    
}
