//
//  PlaceOrderViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 24/04/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol PlaceOrderViewControllerDelegate {
    func userRequestedToPlaceOrder()
}

class PlaceOrderViewController: UIViewController {
    
    var orderOptionsVC: OrderOptionsTableViewController?
    var delegate: PlaceOrderViewControllerDelegate?
    @IBAction func placeOrderAction(_ sender: UIButton) {
        delegate?.userRequestedToPlaceOrder()
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderOptionsView" {
            if let dvc = segue.destination as? OrderOptionsTableViewController {
                orderOptionsVC = dvc
            }
        }
    }

}
