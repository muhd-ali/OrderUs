//
//  OrderedItemTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 20/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class OrderedItemTableViewCell: UITableViewCell {
    @IBOutlet weak var orderedItemImageView: UIImageView!
    @IBOutlet weak var orderedItemNameLabel: UILabel!
    @IBOutlet weak var orderedItemQuantityLabel: UILabel!
    @IBOutlet weak var orderedItemPriceLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var orderedItem: Order.OrderedItem! {
        didSet {
            if orderedItem != nil {
                updateUI()
            }
        }
    }
    
    private func updateUI() {
        orderedItemNameLabel.text = orderedItem.item.Name
        orderedItemQuantityLabel.text = orderedItem.quantity.string1
        orderedItemPriceLabel.text = "PKR \(orderedItem.totalCost)"
        updateImage()
    }
    
    private func updateImage() {
        spinner.startAnimating()
        orderedItem.item.applyImage(to: orderedItemImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
