//
//  ordersTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 10/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class PendingOrdersTableViewController: UITableViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Pending Orders"
    }
    
    // MARK: - Table view data source
    var pendingOrders: [OrdersModel.Order] = OrdersModel.sharedInstance.pendingOrders
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingOrder", for: indexPath)
        
        let order = pendingOrders[indexPath.row]
        
        cell.textLabel?.text = "Placed On: \(order.startedAtshortString)"
        cell.detailTextLabel?.text = "Order ID: \(order.id)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? OrderDetailViewController {
            if let tableListIndex = sender as? Int {
                let selected = pendingOrders[tableListIndex]
                dvc.order = selected
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OrderDetail", sender: indexPath.row)
    }
}
