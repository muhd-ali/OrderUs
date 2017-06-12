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

class SignInRootViewController: UIViewController, GIDSignInUIDelegate, SignInViewControllerDelegate {
    
    @IBOutlet weak var signInView: UIView!
    var viewPosition = CGPoint(x: 0.0, y: 0.0)
    @IBOutlet weak var signUpView: UIView!
    
    var signInViewController: SignInViewController?
    var signUpViewController: SignUpViewController?
    
    func showSignInView() {
        UIView.animate(
        withDuration: 0.5) { [unowned uoSelf = self] in
            uoSelf.signInView.alpha = 1
            uoSelf.signInView.bounds.origin.x -= uoSelf.signUpView.bounds.width
            
            uoSelf.signUpView.alpha = 0
            uoSelf.signUpView.bounds.origin.x -= uoSelf.signUpView.bounds.width
        }
    }
    
    func showSignUpView() {
        UIView.animate(
        withDuration: 0.5) { [unowned uoSelf = self] in
            uoSelf.signInView.alpha = 0
            uoSelf.signInView.bounds.origin.x += uoSelf.signUpView.bounds.width
            
            uoSelf.signUpView.alpha = 1
            uoSelf.signUpView.bounds.origin.x += uoSelf.signUpView.bounds.width
        }
    }
    
    @IBAction func segmentChangedAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showSignInView()
        case 1:
            showSignUpView()
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signUpView.alpha = 0
        signUpView.bounds.origin.x -= signInView.bounds.width
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? SignInViewController {
            signInViewController = dvc
            dvc.delegate = self
        }
        
        if let dvc = segue.destination as? SignUpViewController {
            signUpViewController = dvc
        }
    }
    
    func signInCompleted() {
        performSegue(withIdentifier: "MainMenu", sender: nil)
    }
    
    
    func signedOut() {
        signInViewController?.signedOut()
    }
}

