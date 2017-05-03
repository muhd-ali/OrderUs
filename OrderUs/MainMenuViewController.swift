//
//  MainMenuViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-05-03.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class MainMenuViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var shoppingCartOutlet: MIBadgeButton!
    
    func setShoppingCartBadgeAppearance() {
        let cartItemsCount = ShoppingCartModel.sharedInstance.cartItems.count
        
        if cartItemsCount > 0 {
            shoppingCartOutlet.badgeString = "\(cartItemsCount)"
        } else {
            shoppingCartOutlet.badgeString = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setShoppingCartBadgeAppearance()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
