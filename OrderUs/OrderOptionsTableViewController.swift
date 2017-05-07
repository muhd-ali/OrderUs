//
//  OrderOptionsTableViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-14.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol OrderOptionsTableViewControllerDelegate {
    func doorStepChanged(selectedOption: String)
    func paymentChanged(selectecOption: String)
}

class OrderOptionsTableViewController: UITableViewController {
    var delegate: OrderOptionsTableViewControllerDelegate?
    
    
    internal func showOptionsMenu(options: [(String, String)], message: String, handler: (((String, String)) -> Void)?) {
        let optionsMenu = UIAlertController(title: "Choose Your Preference", message: message, preferredStyle: .actionSheet)
        options.forEach { option in
            optionsMenu.addAction(
                UIAlertAction(title: option.0, style: .default) { _ in
                    if handler != nil {
                        handler!(option)
                    }
                }
            )
        }
        optionsMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(optionsMenu, animated: true, completion: nil)
    }
    
    @IBOutlet weak var doorStepOptionOutlet: UILabel!
    internal func showDoorStepOptionsMenu() {
        showOptionsMenu(options: ShoppingCartModel.Preferences.Doorstep.all, message: "When at my doorstep, the rider should:") { [unowned uoSelf = self] doorStepOption in
            uoSelf.doorStepOptionOutlet.text = doorStepOption.0
            ShoppingCartModel.sharedInstance.order.userDoorStepOption = doorStepOption.1
        }
    }
    
    @IBOutlet weak var paymentOptionOutlet: UILabel!
    internal func showPaymentOptionsMenu() {
        showOptionsMenu(options: ShoppingCartModel.Preferences.Payment.all, message: "I would like to pay:") { [unowned uoSelf = self] paymentOption in
            uoSelf.paymentOptionOutlet.text = paymentOption.0
            ShoppingCartModel.sharedInstance.order.userPaymentOption = paymentOption.1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            showDoorStepOptionsMenu()
        case 1:
            showPaymentOptionsMenu()
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doorStepOptionOutlet.text = ShoppingCartModel.Preferences.Doorstep.initial.0
        paymentOptionOutlet.text = ShoppingCartModel.Preferences.Payment.initial.0
    }
    
    
}
