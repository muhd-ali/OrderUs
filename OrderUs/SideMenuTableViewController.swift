//
//  SideMenuTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 05/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

protocol SideMenuTableViewControllerDelegate {
    func sideMenuDidAppear()
    func sideMenuWillDisappear()
}

class SideMenuTableViewController: UITableViewController {
    
    static var delegate: SideMenuTableViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SideMenuTableViewController.delegate?.sideMenuDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SideMenuTableViewController.delegate?.sideMenuWillDisappear()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FBSDKLoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        SignInModel.sharedInstance.signedIn = false
        let dmDel = DataManager.sharedInstance.delegate
        DataManager.sharedInstance.delegate = DataManager.NullDelegate(called: dmDel.dataChangedFunctionCalled)
        if let vc = presentingViewController as? SignInRootViewController {
            vc.signedOut()
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
