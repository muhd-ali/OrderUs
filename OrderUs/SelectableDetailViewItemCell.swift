//
//  SelectableDetailViewItemCell.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-07-06.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import GMStepper

protocol SelectableDetailViewItemCellDelegate {
    func quantityChanged(at cell: UITableViewCell, from: Double, to: Double)
}

class SelectableDetailViewItemCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemMinQuantityLabel: UILabel!
    @IBOutlet weak var quantityInCartContainer: UIView!
    @IBOutlet weak var priceInCartLabel: UILabel!
    @IBOutlet weak var quantityInCartLabel: UILabel!
    @IBOutlet weak var stepper: GMStepper!
    
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
        stepper.value = Double(orderedItem.units)
        stepper.minimumValue = 0
        stepper.maximumValue = 99
    }
    
    private func updateCartValues() {
        quantityInCartLabel.text = orderedItem.quantityString1
        priceInCartLabel.text = orderedItem.costString
    }
    
    @IBAction func stepperValueChanged(_ sender: GMStepper) {
        let previousValue = orderedItem.units
        let valueIsIncreasing = stepper.valueIsIncreasing(previousValue: previousValue)
        orderedItem.units = stepper.value
        delegate?.quantityChanged(at: self, from: previousValue, to: stepper.value)
        orderedItem.updateInCart()
        var transition = UIViewAnimationOptions.transitionFlipFromBottom
        if valueIsIncreasing {
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
        updateCartValues()
        itemMinQuantityLabel.text = "\(item.minQuantity.costString) per \(item.minQuantity.string2)"
        updateImage()
    }
    
    private func updateImage() {
        spinner.startAnimating()
        item.applyImage(to: itemImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
