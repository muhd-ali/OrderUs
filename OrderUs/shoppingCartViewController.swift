//
//  shoppingCartTableViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import PKHUD

class shoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PlaceOrderViewControllerDelegate {
    
    private var userWantsToPlaceOrder = false
    func userRequestedToPlaceOrder() {
        userWantsToPlaceOrder = true
    }
    
    @IBOutlet weak var cartTableView: UITableView!
    var shoppingCartList: [Order.OrderedItem] = OrdersModel.sharedInstance.order.items
    
    @IBOutlet weak var totalCostDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        updateUI()
    }
    
    private func placeOrder() {
        let result = OrdersModel.sharedInstance.placeOrder()
        switch result {
        case .success:
            HUD.flash(
                .labeledSuccess(title: "Order Placed", subtitle: "Please wait while we process"),
                delay: 0.5) { [unowned uoSelf = self] _ in
                    _ = uoSelf.navigationController?.popViewController(animated: true)
            }
        case .notSignedIn:
            HUD.flash(
                .labeledError(title: "Sign In", subtitle: "Please sign in and try again"),
                delay: 0.5
            )
        case .noLocationFound:
            HUD.flash(
                .labeledError(title: "Location", subtitle: "Please enable location services and try again"),
                delay: 0.5
            )
}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userWantsToPlaceOrder {
            placeOrder()
        }
    }
    
    @IBOutlet weak var proceedButtonOutlet: UIButton!
    private func updateUI() {
        title = "Shopping Cart"
        let totalCost = shoppingCartList.reduce(0) { $0 + ($1.totalCost()) }
        totalCostDisplay.text = "Total Cost = \(totalCost) PKR"
        if shoppingCartList.count == 0 {
            proceedButtonOutlet.isEnabled = false
            proceedButtonOutlet.setTitle("Cart is Empty", for: .disabled)
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return shoppingCartList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCartItem", for: indexPath)
        
        let cartItem = shoppingCartList[indexPath.section]
        cell.textLabel?.text = cartItem.item.Name
        cell.detailTextLabel?.text = "\(cartItem.quantityValue) \(cartItem.quantityUnit) for \(cartItem.totalCost()) PKR"
        
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            shoppingCartList.remove(at: indexPath.section)
            OrdersModel.sharedInstance.order.items = shoppingCartList
            updateUI()
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
        default: break
        }
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        performSegue(withIdentifier: "placeOrderView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeOrderView" {
            if let dvc = segue.destination as? PlaceOrderViewController {
                dvc.delegate = self
            }
        }
    }
    
}
