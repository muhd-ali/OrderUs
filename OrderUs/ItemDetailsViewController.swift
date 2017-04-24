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
    
    var item: DataManager.Item? {
        didSet {
            if item != nil {
                itemName = item!.Name
                itemDescription = item!.Description
                itemImageURL = item!.ImageURL
                itemPrice = item!.Price
                itemMinQuantity = item!.MinQuantity
            }
        }
    }
    
    private struct NotFound {
        static let itemName = "no type found"
        static let itemDescription = "no description found"
        static let itemImageURL = "no url found"
        static let itemPrice = -1.0
        static let itemMinQuantity:[DataManager.Item.MinQuantityKey : Any] = [.Number : -1, .Unit : "not found"]
    }
    
    private var itemName = NotFound.itemName
    private var itemDescription = NotFound.itemDescription
    private var itemImageURL = NotFound.itemImageURL
    private var itemPrice = NotFound.itemPrice
    private var itemMinQuantity = NotFound.itemMinQuantity
    private var itemQuantityValue = 0.0 {
        didSet {
            itemQuantityUnit = itemMinQuantity[.Unit] as! String
            if (itemQuantityValue > 1.0) {
                itemQuantityUnit = itemQuantityUnit + "s"
            }
        }
    }
    private var itemQuantityUnit = ""
    
    
    
    @IBOutlet weak var quantityStepperOutlet: QuantityStepper!
    @IBAction func quantityStepperValueChangedAction(_ sender: QuantityStepper) {
        quantityStepperOutlet.previousValue = itemQuantityValue
        itemQuantityValue = quantityStepperOutlet.value
        updateDynamicContent(increasingValues: quantityStepperOutlet.valueIsIncreasing)
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        var cartItems = ShoppingCartModel.sharedInstance.cartItems
        let currentThisItemInCart = cartItems.filter { cartItem -> Bool in cartItem.item.ID == item!.ID }
        if (currentThisItemInCart.count == 0) {
            cartItems.append(
                ShoppingCartModel.OrderedItem(
                    item: item!,
                    quantityValue: itemQuantityValue,
                    quantityUnit: itemQuantityUnit
                )
            )
            ShoppingCartModel.sharedInstance.cartItems = cartItems
        } else {
            ShoppingCartModel.sharedInstance.cartItems = cartItems.map {
                var newItem = $0
                if (newItem.item.ID == item!.ID) {
                    newItem.quantityValue += itemQuantityValue
                }
                return newItem
            }
        }
        
        HUD.flash(
            .labeledSuccess(title: "Added To Cart", subtitle: nil),
            delay: 0.5) { [unowned uoSelf = self] finished in
                if finished {
                    _ = uoSelf.navigationController?.popViewController(animated: true)
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityStepperOutlet.minimumValue = itemMinQuantity[.Number] as? Double ?? 1
        quantityStepperOutlet.stepValue = quantityStepperOutlet.minimumValue
        itemQuantityValue = quantityStepperOutlet.minimumValue
        updateUI()
    }
    
    private func updateUI() {
        itemNameLabel.text = itemName
        updateImage()
        updateDynamicContent(increasingValues: true)
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
            duration: 0.25,
            options: [.curveEaseInOut, transitionEffect],
            animations: { [unowned uoSelf = self] in
                uoSelf.itemQuantityLabel.text = "\(uoSelf.quantityStepperOutlet.value) \(uoSelf.itemQuantityUnit)"
            },
            completion: nil
        )
        
        UIView.transition(
            with: itemPriceLabel,
            duration: 0.25,
            options: [.curveEaseInOut, transitionEffect],
            animations: { [unowned uoSelf = self] in
                uoSelf.itemPriceLabel.text = "\((uoSelf.itemPrice/uoSelf.quantityStepperOutlet.minimumValue) * uoSelf.quantityStepperOutlet.value) PKR"
            },
            completion: nil
        )
        
        
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private func updateImage() {
        if let url = NSURL(string: itemImageURL) {
            spinner.startAnimating()
            DispatchQueue(
                label: "downloading image for \(itemName)",
                qos: .userInitiated,
                attributes: .concurrent
                ).async {
                    if let imageData = NSData(contentsOf: url as URL) {
                        DispatchQueue.main.async { [weak weakSelf = self] in
                            weakSelf?.spinner.stopAnimating()
                            if weakSelf?.itemImageURL == url.absoluteString {
                                weakSelf?.itemImageView.image = UIImage(data: imageData as Data)
                            }
                        }
                    }
            }
        }
    }
}
