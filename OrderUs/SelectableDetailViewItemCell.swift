//
//  SelectableDetailViewItemCell.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-07-06.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SelectableDetailViewItemCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemMinQuantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
    }
    @IBOutlet weak var quantityInCartContainer: UIView!
    @IBOutlet weak var quantityInCartLabel: UILabel!
    
    var item: Item! {
        didSet {
            if item != nil {
                updateUI()
            }
        }
    }
    
    private func updateUI() {
        itemNameLabel.text = item.Name
        itemPriceLabel.text = "PKR \(item.Price)"
        itemMinQuantityLabel.text = item.minQuantity.string1
        updateImage()
    }
    
    private func updateImage() {
        spinner.startAnimating()
        item.applyImage(to: itemImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
