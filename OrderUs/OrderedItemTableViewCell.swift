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
        orderedItemQuantityLabel.text = "\(orderedItem.quantityValue) \(orderedItem.quantityUnit)"
        orderedItemPriceLabel.text = "PKR \(orderedItem.totalCost)"
        updateImage()
    }
    
    private func updateImage() {
        if let url = URL(string: orderedItem.item.ImageURL) {
            spinner.startAnimating()
            orderedItemImageView.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }
}
