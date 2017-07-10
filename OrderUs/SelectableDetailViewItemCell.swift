//
//  SelectableDetailViewItemCell.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-07-06.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol SelectableDetailViewItemCellDelegate {
    func quantityChanged(at cell: UITableViewCell, from: Double, to: Double)
}

class SelectableDetailViewItemCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemMinQuantityLabel: UILabel!
    @IBOutlet weak var stepper: QuantityStepper!
    @IBOutlet weak var quantityInCartContainer: UIView!
    @IBOutlet weak var priceInCartLabel: UILabel!
    @IBOutlet weak var quantityInCartLabel: UILabel!
    
    var delegate: SelectableDetailViewItemCellDelegate?
    var item: Item! {
        didSet {
            if item != nil {
                orderedItem = item.orderedItem
                setupStepper()
                updateUI()
            }
        }
    }
    
    private var orderedItem: Order.OrderedItem!
    
    private func setupStepper() {
        stepper.stepValue = item.minQuantity.Number
        stepper.value = orderedItem.quantity.Number
        stepper.minimumValue = 0
        stepper.maximumValue = 100 * item.minQuantity.Number
    }
    
    private func updateCartValues() {
        quantityInCartLabel.text = orderedItem.quantity.string1
        priceInCartLabel.text = orderedItem.totalCostString
    }
    
    @IBAction func stepperValueChanged(_ sender: QuantityStepper) {
        stepper.previousValue = orderedItem.quantity.Number
        orderedItem.quantity.Number = stepper.value
        delegate?.quantityChanged(at: self, from: stepper.previousValue!, to: stepper.value)
        orderedItem.updateInCart()
        var transition = UIViewAnimationOptions.transitionFlipFromBottom
        if stepper.valueIsIncreasing {
            transition = UIViewAnimationOptions.transitionFlipFromTop
        }
        UIView.transition(
            with: quantityInCartContainer,
            duration: MainMenuViewController.Constants.animationDuration,
            options: [.curveEaseInOut, transition],
            animations: { [unowned uoSelf = self] in
                uoSelf.updateCartValues()
            },
            completion: nil
        )
    }
    
    private func updateUI() {
        itemNameLabel.text = item.Name
        itemPriceLabel.text = "PKR \(item.Price)"
        updateCartValues()
        itemMinQuantityLabel.text = item.minQuantity.string2
        updateImage()
    }
    
    private func updateImage() {
        spinner.startAnimating()
        item.applyImage(to: itemImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
