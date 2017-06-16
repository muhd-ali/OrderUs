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
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var item: Item! {
        didSet {
            if item != nil {
                itemName = item.Name
                itemImageURL = item.ImageURL
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
    
    private func updateUI() {
        itemLabel.text = itemName
        itemImageView.image = nil
        updateImage()
        updatePriceLabel()
        updateItemQuantityLabel()
    }
    
    private func updateItemQuantityLabel() {
        var quantity = "None added in cart"
        if let orderedItem = OrdersModel.sharedInstance.order.getItem(withID: item.ID) {
            quantity = "\(orderedItem.quantityValue) \(orderedItem.quantityUnit) in cart"
        }
        
        itemQuantityLabel.text = quantity
    }
    
    private func updatePriceLabel() {
        let price = String(describing: item?.Price ?? 0)
        let minQuantityNumber = String(describing: item?.minQuantity.Number ?? 0)
        let minQuantityUnit = String(describing: item?.minQuantity.Unit ?? "")
        
        itemPriceLabel.text = "PKR \(price) / \(minQuantityNumber) \(minQuantityUnit)"
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
        print(OrdersModel.sharedInstance.order.items)
        if var orderedItem = OrdersModel.sharedInstance.order.getItem(withID: item.ID) {
            quantityStepperOutlet.previousValue = orderedItem.quantityValue
            orderedItem.quantityValue += quantityStepperOutlet.value
        } else {
            let quantity = quantityStepperOutlet.value
            let unit = item.minQuantity.Unit
            let orderedItem = Order.OrderedItem(item: item, quantityValue: quantity, quantityUnit: quantity == 1 ? unit : "\(unit)s")
            OrdersModel.sharedInstance.order.items.append(orderedItem)
        }
    }
}
