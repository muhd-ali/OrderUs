//
//  PlaceOrderViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 24/04/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import PKHUD

protocol PlaceOrderViewControllerDelegate {
    func userRequestedToPlaceOrder()
}

class PlaceOrderViewController: UIViewController {
    
    var orderOptionsVC: OrderOptionsTableViewController?
    var delegate: PlaceOrderViewControllerDelegate?
    
    @IBOutlet weak var addressOutlet: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        let addressLines = DataManager.sharedInstance.orderLocation?.addressLines ?? []
        if addressLines.count > 0 {
            addressOutlet.text = addressLines.reduce("") { (result, address) in
                if result.isEmpty {
                    return address
                } else {
                    return result + "\n" + address
                }
            }
        }
    }
    
    @IBAction func placeOrderAction(_ sender: UIButton) {
        if OrdersModel.sharedInstance.nextOrderCanBePlaced {
            delegate?.userRequestedToPlaceOrder()
            _ = navigationController?.popViewController(animated: true)
        } else {
            HUD.flash(
                .labeledProgress(
                    title: "Please Wait",
                    subtitle: "Please wait while your previous order is acknowledged"
                ),
                delay: 0.5
            )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderOptionsView" {
            if let dvc = segue.destination as? OrderOptionsTableViewController {
                orderOptionsVC = dvc
            }
        }
    }
    
}
