//
//  ItemDetailsViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-07.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import PKHUD

class ItemDetailsViewController: UIViewController {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    
    private var orderedItem: Order.OrderedItem!
    var item: Item!
    
    let appTintColor = MainMenuViewController.Constants.appTintColor
    
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBAction func didPressCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var quantityStepperOutlet: QuantityStepper!
    @IBAction func quantityStepperValueChangedAction(_ sender: QuantityStepper) {
        quantityStepperOutlet.previousValue = orderedItem.units
        orderedItem.units = quantityStepperOutlet.value
        updateDynamicContent(increasingValues: quantityStepperOutlet.valueIsIncreasing)
    }
    
    private func setupStepper() {
        quantityStepperOutlet.minimumValue = 0
        quantityStepperOutlet.maximumValue = 100 * item.minQuantity.Number
        quantityStepperOutlet.value = orderedItem.units
        quantityStepperOutlet.stepValue = item.minQuantity.Number
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if item != nil {
            orderedItem = item.orderedItem
            setupStepper()
            updateUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OrdersModel.sharedInstance.currentOrder.set(item: orderedItem)
    }
    
    func setupStatusBar() {
        let statusBar = UIApplication.shared.statusBarView
        statusBar?.backgroundColor = appTintColor
        statusBar?.tintColor = UIColor.white
    }
    
    private func updateUI() {
        setupStatusBar()
        itemNameLabel.text = item.Name
        titleItem.title = item.Name
        updateImage()
        updateDynamicContent(increasingValues: true)
    }
    
    private func updateDynamicContent(increasingValues: Bool) {
        var transitionEffect: UIViewAnimationOptions
        if increasingValues {
            transitionEffect = .transitionFlipFromTop
        } else {
            transitionEffect = .transitionFlipFromBottom
        }
        
        UIView.transition(
            with: itemQuantityLabel,
            duration: 0.2,
            options: [.curveEaseInOut, transitionEffect],
            animations: { [unowned uoSelf = self] in
                uoSelf.itemQuantityLabel.text = uoSelf.orderedItem.quantityString1
            },
            completion: nil
        )
        
        UIView.transition(
            with: itemPriceLabel,
            duration: 0.25,
            options: [.curveEaseInOut, transitionEffect],
            animations: { [unowned uoSelf = self] in
                uoSelf.itemPriceLabel.text = "\(uoSelf.orderedItem.totalCost) PKR"
            },
            completion: nil
        )
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private func updateImage() {
        spinner.startAnimating()
        item.applyImage(to: itemImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
