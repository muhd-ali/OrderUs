//
//  ordersTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 10/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Table view data source
    var orders: [Order] = OrdersModel.sharedInstance.placedOrders.pending
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? OrderDetailViewController {
            if let tableListIndex = sender as? Int {
                let selected = orders[tableListIndex]
                dvc.order = selected
            }
        }
    }
}

extension OrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OrderDetail", sender: indexPath.row)
    }
}

extension OrdersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingOrder", for: indexPath)
        
        let order = orders[indexPath.row]
        
        cell.textLabel?.text = "Placed On: \(order.startedAtshortString)"
        cell.detailTextLabel?.text = "Order ID: \(order.id)"
        
        return cell
    }
}
