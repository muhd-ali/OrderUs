//
//  shoppingCartTableViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import PKHUD

class shoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cartTableView: UITableView!
    var shoppingCartList: [ShoppingCartModel.OrderedItem] = ShoppingCartModel.sharedInstance.cartItems
    
    @IBOutlet weak var totalCostDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        updateUI()
    }
    
    func updateUI() {
        title = "Shopping Cart"
        let totalCost = shoppingCartList.reduce(0) { $0 + ($1.item.Price * $1.quantity) }
        totalCostDisplay.text = "Total Cost = \(totalCost) PKR"
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
        cell.detailTextLabel?.text = "Ordered \(cartItem.quantity) for \(cartItem.item.Price * cartItem.quantity)"
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
    
    @IBAction func placeOrderAction(_ sender: UIButton) {
        ShoppingCartModel.sharedInstance.cartItems = []
        HUD.flash(.success, delay: 0.5) { [unowned uoSelf = self] finished in
            _ = uoSelf.navigationController?.popViewController(animated: true)
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
