//
//  SignUpViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 30/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var emailAddressOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var confirmPasswordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [(nameOutlet, "Enter Your Name"), (emailAddressOutlet, "Enter Your Email Address"), (passwordOutlet, "Enter Your Password"), (confirmPasswordOutlet, "Confirm Your Password")].forEach { (textField, placeholderText) in
            textField?.layer.borderWidth = 2
            textField?.layer.borderColor = UIColor.white.cgColor
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange]
            )
        }
    }

}
