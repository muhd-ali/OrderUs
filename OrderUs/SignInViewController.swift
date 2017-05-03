//
//  ViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-02-24.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import FacebookLogin

class SignInViewController: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!

    @IBAction func signInButton(_ sender: UIButton) {
        if (loadingCircle.isAnimating) {
            loadingCircle.stopAnimating()
        } else {
            loadingCircle.startAnimating()
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }
    
    // Login Button Delegate API
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        //
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        //
    }
    
}

