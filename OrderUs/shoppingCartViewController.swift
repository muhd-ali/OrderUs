//
//  shoppingCartTableViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import PKHUD

class shoppingCartViewController: UIViewController, PlaceOrderViewControllerDelegate {
    
    private var userAskedToPlaceOrder = false
    func userRequestedToPlaceOrder() {
        userAskedToPlaceOrder = true
    }
    
    @IBOutlet weak var cartTableView: UITableView!
    internal var  currentOrder = OrdersModel.sharedInstance.currentOrder
    internal var shoppingCartList: [Order.OrderedItem] = []
    
    @IBOutlet weak var totalCostDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        let detailItemCell = SelectableViewController.Constant.CellName.detailItemCell
        let nib = UINib(nibName: detailItemCell, bundle: nil)
        cartTableView.register(nib, forCellReuseIdentifier: detailItemCell)
        shoppingCartList = currentOrder.items
        cartTableView.dataSource = self
        cartTableView.delegate = self
        updateUI()
    }
    
    @IBOutlet weak var capacityProgressView: UIProgressView!
    @IBAction func didPressCapacityDetailDisclosure(_ sender: UIButton) {
        let controller = (storyboard?.instantiateViewController(withIdentifier: "popoverView"))!
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        let width = 0.5 * view.bounds.width; let height = 0.25 * view.bounds.height
        controller.preferredContentSize = CGSize(width: width, height: height)
        if let popController = controller.popoverPresentationController {
            popController.permittedArrowDirections = .any
            popController.backgroundColor = MainMenuViewController.Constants.appTintColor
            popController.delegate = self
            popController.sourceRect = sender.bounds
            popController.sourceView =  sender
        }
        
        self.present(controller, animated: true, completion: nil)
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
        case .pendingOrderInQueue:
            HUD.flash(
                .labeledProgress(
                    title: "Please Wait",
                    subtitle: "Please wait while your previous order is acknowledged"
                ),
                delay: 0.5
            )
        }
        userAskedToPlaceOrder = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userAskedToPlaceOrder {
            placeOrder()
        }
    }
    
    internal func updateTotalCost() {
        let totalCost = shoppingCartList.reduce(0) { $0 + ($1.totalCost) }
        totalCostDisplay.text = "PKR \(totalCost)"
    }
    
    @IBOutlet weak var proceedButtonOutlet: UIButton!
    internal func updateUI() {
        title = "Shopping Cart"
        updateTotalCost()
        proceedButtonOutlet.setTitleColor(UIColor.gray, for: .disabled)
        if shoppingCartList.count == 0 {
            proceedButtonOutlet.isEnabled = false
            proceedButtonOutlet.setTitle("Cart is Empty", for: .disabled)
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

extension shoppingCartViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension shoppingCartViewController: SelectableDetailViewItemCellDelegate {
    func quantityChanged(at cell: UITableViewCell, from: Double, to: Double) {
        updateTotalCost()
    }
}

extension shoppingCartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return shoppingCartList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectableViewController.Constant.CellName.detailItemCell, for: indexPath)
        if let itemCell = cell as? SelectableDetailViewItemCell {
            itemCell.item = shoppingCartList[indexPath.section].item
            itemCell.delegate = self
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension shoppingCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let item = shoppingCartList[indexPath.section]
            currentOrder.removeItem(withID: item.item.ID)
            shoppingCartList = currentOrder.items
            tableView.deleteSections(
                IndexSet(integer: indexPath.section),
                with: .automatic
            )
            updateUI()
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2.5 * 0.25 * view.bounds.width
    }
}
