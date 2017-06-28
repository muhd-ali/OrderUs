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
    var item: Item! {
        didSet {
            if item != nil {
                orderedItem = Order.OrderedItem(item: item, quantity: item.minQuantity.Number)
                if isViewLoaded {
                    updateUI()
                }
            }
        }
    }
    
    let appTintColor = MainMenuViewController.Constants.appTintColor
    
    
    
    @IBOutlet weak var quantityStepperOutlet: QuantityStepper!
    @IBAction func quantityStepperValueChangedAction(_ sender: QuantityStepper) {
        quantityStepperOutlet.previousValue = orderedItem.quantity.Number
        orderedItem.quantity.Number = quantityStepperOutlet.value
        updateDynamicContent(increasingValues: quantityStepperOutlet.valueIsIncreasing)
    }
    
    private func setupStepper() {
        quantityStepperOutlet.minimumValue = item.minQuantity.Number
        quantityStepperOutlet.maximumValue = 100 * item.minQuantity.Number
        quantityStepperOutlet.stepValue = quantityStepperOutlet.minimumValue
        orderedItem.quantity.Number = quantityStepperOutlet.minimumValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil {
            setupStepper()
            updateUI()
        }
    }
    
    func setupStatusBar() {
        let statusBar = UIApplication.shared.statusBarView
        statusBar?.backgroundColor = appTintColor
        statusBar?.tintColor = UIColor.white
    }
    
    private func updateUI() {
        setupStatusBar()
        itemNameLabel.text = item.Name
        updateImage()
        updateDynamicContent(increasingValues: true)
    }
    
    private func getTotalPrice() -> Double {
        return item.Price / quantityStepperOutlet.minimumValue * quantityStepperOutlet.value
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
                uoSelf.itemQuantityLabel.text = uoSelf.orderedItem.quantity.string1
            },
            completion: nil
        )
        
        UIView.transition(
            with: itemPriceLabel,
            duration: 0.25,
            options: [.curveEaseInOut, transitionEffect],
            animations: { [unowned uoSelf = self] in
                uoSelf.itemPriceLabel.text = "\(uoSelf.getTotalPrice()) PKR"
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
