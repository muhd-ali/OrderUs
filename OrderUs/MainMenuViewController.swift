//
//  MainMenuViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-05-03.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import FBSDKLoginKit
import GoogleSignIn

class MainMenuViewController: UITabBarController {
    @IBOutlet weak var shoppingCartOutlet: MIBadgeButton!
    
    @IBOutlet weak var trackOrdersButtonOutlet: MIBadgeButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBadges()
    }
    
    private func setShoppingCartBadge() {
        let cartItemsCount = OrdersModel.sharedInstance.order.items.count
        
        if cartItemsCount > 0 {
            shoppingCartOutlet.badgeString = "\(cartItemsCount)"
        } else {
            shoppingCartOutlet.badgeString = nil
        }
    }
    
    private func setTrackOrderBadge() {
        let orderedItemsCount = OrdersModel.sharedInstance.orders.count
        
        if orderedItemsCount > 0 {
            trackOrdersButtonOutlet.badgeString = "\(orderedItemsCount)"
        } else {
            trackOrdersButtonOutlet.badgeString = nil
        }
    }
    
    private func setBadges() {
        setShoppingCartBadge()
        setTrackOrderBadge()
    }

    
    @IBAction func signOutButtonAction(_ sender: UIButton) {
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
