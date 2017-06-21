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
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private var orderedItem: Order.OrderedItem!
    var item: Item! {
        didSet {
            if item != nil {
                orderedItem = Order.OrderedItem(item: item!, quantity: item!.minQuantity.Number)
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
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        var cartItems = OrdersModel.sharedInstance.currentOrder.items
        let currentThisItemInCart = cartItems.filter { cartItem -> Bool in cartItem.item.ID == item!.ID }
        if (currentThisItemInCart.count == 0) {
            cartItems.append(orderedItem)
            OrdersModel.sharedInstance.currentOrder.items = cartItems
        } else {
            OrdersModel.sharedInstance.currentOrder.items = cartItems.map {
                let newItem = $0
                if (newItem.item.ID == item!.ID) {
                    newItem.quantity.Number += orderedItem.quantity.Number
                }
                return newItem
            }
        }
        
        
        HUD.flash(
            .labeledSuccess(title: "Added To Cart", subtitle: nil),
            delay: 0.5) { [unowned uoSelf = self] finished in
                if finished {
                    uoSelf.dismiss(animated: true, completion: nil)
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityStepperOutlet.minimumValue = item!.minQuantity.Number
        quantityStepperOutlet.stepValue = quantityStepperOutlet.minimumValue
        orderedItem.quantity.Number = quantityStepperOutlet.minimumValue
        updateUI()
    }
    
    func setupStatusBar() {
        let statusBar = UIApplication.shared.statusBarView
        statusBar?.backgroundColor = appTintColor
        statusBar?.tintColor = UIColor.white
    }
    
    func setupNavigationBar() {
        navigationBar.items?.last?.title = item?.Name
    }
    
    private func updateUI() {
        setupStatusBar()
        setupNavigationBar()
        itemNameLabel.text = item?.Name
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
        if let url = URL(string: item.ImageURL) {
            spinner.startAnimating()
            itemImageView.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }
}
