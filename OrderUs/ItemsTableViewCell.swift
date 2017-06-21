//
//  CategoriesTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import SDWebImage

class ItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemMinQuantityLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemQuantityInCartLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var item: Item! {
        didSet {
            if item != nil {
                itemName = item.Name
                itemImageURL = item.ImageURL
                orderedItem = OrdersModel.sharedInstance.currentOrder.getItem(withID: item.ID)
                updateUI()
            }
        }
    }
    
    
    struct NotFound {
        static let itemName = "no type found"
        static let itemImageURL = "no url found"
    }
    
    var itemName = NotFound.itemName
    var itemImageURL = NotFound.itemImageURL
    var orderedItem: Order.OrderedItem!
    
    private func updateUI() {
        itemLabel.text = itemName
        itemImageView.image = nil
        updateImage()
        updatePriceDisplay()
        updateItemQuantityLabel()
        setStepperUI()
    }
    
    private func setStepperUI() {
        quantityStepperOutlet.setIncrementImage(#imageLiteral(resourceName: "stepperPlus"), for: .normal)
        quantityStepperOutlet.setDecrementImage(#imageLiteral(resourceName: "stepperMinus"), for: .normal)
        let image = #imageLiteral(resourceName: "stepperBkg")
        quantityStepperOutlet.setBackgroundImage(image, for: .normal)
        quantityStepperOutlet.setBackgroundImage(image, for: .disabled)
        quantityStepperOutlet.setBackgroundImage(image, for: .highlighted)
    }
    
    private func updateItemQuantityLabel() {
        var quantity = "None added in cart"
        if orderedItem != nil {
            quantity = "\(orderedItem.quantity.string1) in cart"
            quantityStepperOutlet.value = orderedItem.quantity.Number
        } else {
            quantityStepperOutlet.value = 0
        }
        itemQuantityInCartLabel.text = quantity
    }
    
    private func updatePriceDisplay() {
        itemPriceLabel.text = "PKR \(item.Price)"
        itemMinQuantityLabel.text = "\(item.minQuantity.string2)"
    }
    
    private func updateImage() {
        if let url = URL(string: itemImageURL) {
            spinner.startAnimating()
            itemImageView.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }
    
    
    @IBOutlet weak var quantityStepperOutlet: QuantityStepper!
    @IBAction func quantityStepperValueChanged(_ sender: QuantityStepper) {
        let currentValue = quantityStepperOutlet.value
        if orderedItem != nil {
            quantityStepperOutlet.previousValue = orderedItem.quantity.Number
            if currentValue == 0 {
                OrdersModel.sharedInstance.currentOrder.removeItem(withID: item.ID)
                orderedItem = nil
            } else {
                orderedItem.quantity.Number = quantityStepperOutlet.value
            }
        } else {
            orderedItem = Order.OrderedItem(
                item: item,
                quantity: currentValue
            )
            OrdersModel.sharedInstance.currentOrder.items.append(orderedItem)
        }
        
        var transitionEffect = UIViewAnimationOptions.transitionFlipFromBottom
        if quantityStepperOutlet.valueIsIncreasing {
            transitionEffect = .transitionFlipFromTop
        }
        UIView.transition(
            with: itemQuantityInCartLabel,
            duration: 0.2,
            options: [transitionEffect, .curveEaseInOut],
            animations: { [unowned uoSelf = self] in
                uoSelf.updateItemQuantityLabel()
            },
            completion: nil
        )
    }
}
