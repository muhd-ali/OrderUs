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
                orderedItem = OrdersModel.sharedInstance.order.getItem(withID: item.ID)
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
        quantityStepperOutlet.setBackgroundImage(image, for: .focused)
        quantityStepperOutlet.setBackgroundImage(image, for: .selected)
    }
    
    private func updateItemQuantityLabel() {
        var quantity = "None added in cart"
        if orderedItem != nil {
            let value = orderedItem.quantityValue
            quantity = "\(value) \(orderedItem.quantityUnit)\(value == 1 ? "" : "s") in cart"
            quantityStepperOutlet.value = value
        }
        itemQuantityInCartLabel.text = quantity
    }
    
    private func updatePriceDisplay() {
        let priceStr = String(describing: item.Price)
        let minQuantityNumber = item.minQuantity.Number
        let minQuantityNumberStr = minQuantityNumber == 1 ? "each" : String(describing: minQuantityNumber)
        let minQuantityUnit = item.minQuantity.Unit
        let minQuantityUnitStr = minQuantityNumber == 1 ? minQuantityUnit : "\(minQuantityUnit)s"
        
        itemPriceLabel.text = "PKR \(priceStr)"
        itemMinQuantityLabel.text = "\(minQuantityNumberStr) \(minQuantityUnitStr)"
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
            quantityStepperOutlet.previousValue = orderedItem.quantityValue
            if currentValue == 0 {
                OrdersModel.sharedInstance.order.removeItem(withID: item.ID)
                orderedItem = nil
            } else {
                orderedItem.quantityValue = quantityStepperOutlet.value
            }
        } else {
            let unit = item.minQuantity.Unit
            orderedItem = Order.OrderedItem(item: item, quantityValue: currentValue, quantityUnit: currentValue == 1 ? unit : "\(unit)s")
            OrdersModel.sharedInstance.order.items.append(orderedItem)
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
