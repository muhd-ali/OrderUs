//
//  shoppingCartTableViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import PKHUD

class shoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OrderOptionsTableViewControllerDelegate, PlaceOrderViewControllerDelegate {
    
    internal var doorStepOption = OrderOptionsTableViewController.DoorStepOption.ringDoorBell
    func doorStepChanged(selectedOption: OrderOptionsTableViewController.DoorStepOption) {
        doorStepOption = selectedOption
    }
    
    internal var userWantsToPlaceOrder = false
    func userRequestedToPlaceOrder() {
        userWantsToPlaceOrder = true
    }
    
    @IBOutlet weak var cartTableView: UITableView!
    var shoppingCartList: [ShoppingCartModel.OrderedItem] = ShoppingCartModel.sharedInstance.cartItems
    
    @IBOutlet weak var totalCostDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        updateUI()
    }
    
    internal func placeOrder() {
        ServerCommunicator.sharedInstance.placeOrder()
        ShoppingCartModel.sharedInstance.cartItems = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userWantsToPlaceOrder {
            placeOrder()
            HUD.flash(
                .labeledSuccess(title: "Order Placed", subtitle: "Please wait while we process"),
                delay: 0.5) { [unowned uoSelf = self] _ in
                    _ = uoSelf.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBOutlet weak var proceedButtonOutlet: UIButton!
    internal func updateUI() {
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
            ShoppingCartModel.sharedInstance.cartItems = shoppingCartList
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
                dvc.orderOptionsVC?.delegate = self
                dvc.delegate = self
            }
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
