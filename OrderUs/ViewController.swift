//
//  ViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-02-24.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!

    @IBAction func signInButton(_ sender: UIButton) {
        if (loadingCircle.isAnimating) {
            loadingCircle.stopAnimating()
        } else {
            loadingCircle.startAnimating()
        }
    }
}

