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
    @IBOutlet weak var orderDetailsContainerView: UIView!
    internal var orderDetailViewController: OrderDetailViewController?
    @IBOutlet weak var noOrdersContainerView: UIView!
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.layer.zPosition = 2
    }
    
    private func setupDetailsView() {
        if orders.count == 0 {
            orderDetailsContainerView.removeFromSuperview()
        } else {
            noOrdersContainerView.removeFromSuperview()
        }
    }
    
    private func updateUI() {
        self.title = "Track Orders"
        setupTableView()
        setupDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    var orders: [Order] = OrdersModel.sharedInstance.placedOrders.pending
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? OrderDetailViewController, orders.count > 0 {
            orderDetailViewController = dvc
            dvc.order = orders[selectedRowIndex.row]
        }
    }
    
    internal var selectedRowIndex = IndexPath(row: 0, section: 0)
}

extension OrdersViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Pending"
//        default:
//            return ""
//        }
//    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard indexPath != selectedRowIndex else { return }
//        let animationDuration: TimeInterval = 0.2
//        let frame = orderDetailsContainerView.frame
//        let lastSelectedRowIndex = selectedRowIndex
//        let lastSelectedCell = tableView.cellForRow(at: lastSelectedRowIndex)!
//        let lastSelectedCellFrameInView = lastSelectedCell.convert(lastSelectedCell.frame, to: view)
//        orderDetailsContainerView.frame = CGRect(x: lastSelectedCellFrameInView.origin.x, y: lastSelectedCellFrameInView.midY, width: 1, height: 1)
//        UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
//            uoSelf.orderDetailsContainerView.layoutIfNeeded()
//        }) { [unowned uoSelf = self] (completed) in
//            if completed {
//                uoSelf.selectedRowIndex = indexPath
//                uoSelf.orderDetailViewController.order = uoSelf.orders[uoSelf.selectedRowIndex.row]
//                tableView.reloadRows(at: [lastSelectedRowIndex, indexPath], with: .automatic)
//                
//                uoSelf.orderDetailsContainerView.frame = frame
//                UIView.animate(withDuration: animationDuration, animations: {
//                    uoSelf.orderDetailsContainerView.layoutIfNeeded()
//                })
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath != selectedRowIndex else { return }
        let animationDuration: TimeInterval = 0.2
        UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
            let frame = uoSelf.orderDetailsContainerView.frame
            uoSelf.orderDetailsContainerView.frame = frame.offsetBy(dx: -frame.width, dy: 0)
            uoSelf.orderDetailViewController?.viewDidDisappear(true)
        }) { [unowned uoSelf = self] (completed1) in
            if completed1 {
                let oldSelectedRowIndex = uoSelf.selectedRowIndex
                uoSelf.selectedRowIndex = indexPath
                uoSelf.orderDetailViewController?.order = uoSelf.orders[uoSelf.selectedRowIndex.row]
                tableView.reloadRows(at: [oldSelectedRowIndex, indexPath], with: .automatic)
                
                UIView.animate(withDuration: animationDuration, animations: {
                    let frame = uoSelf.orderDetailsContainerView.frame
                    uoSelf.orderDetailsContainerView.frame = frame.offsetBy(dx: frame.width, dy: 0)
                }) { (completed2) in
                    if completed2 {
                        uoSelf.orderDetailViewController?.viewDidAppear(true)
                    }
                }
                
            }
        }
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
        
        cell.textLabel?.text = order.timeStamp?.startedAt.shortTime
        cell.detailTextLabel?.text = order.timeStamp?.startedAt.shortDate
        
        if indexPath.row == selectedRowIndex.row {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor.white
            cell.detailTextLabel?.textColor = UIColor.white
        }
        
        return cell
    }
}
