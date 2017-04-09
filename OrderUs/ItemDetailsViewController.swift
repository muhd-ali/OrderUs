//
//  ItemDetailsViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-04-07.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    
    var item: DataManager.Categories.CategoryType? {
        didSet {
            itemName = (item?[.Name] as? String) ?? NotFound.itemName
            itemDescription = (item?[.Description] as? String) ?? NotFound.itemName
            itemImageURL = (item?[.ImageURL] as? String) ?? NotFound.itemName
            itemPrice = (item?[.Price] as? Double) ?? NotFound.itemPrice
            itemMinQuantity = (item?[.MinQuantity] as? [DataManager.Categories.Key:Any]) ?? NotFound.itemMinQuantity
        }
    }
    
    private struct NotFound {
        static let itemName = "no type found"
        static let itemDescription = "no description found"
        static let itemImageURL = "no url found"
        static let itemPrice = -1.0
        static let itemMinQuantity:[DataManager.Categories.Key : Any] = [DataManager.Categories.Key.MinQuanityNumber: -1, .MinQuantityUnit: "not found"]
    }
    
    private var itemName = NotFound.itemName
    private var itemDescription = NotFound.itemDescription
    private var itemImageURL = NotFound.itemImageURL
    private var itemPrice = NotFound.itemPrice
    private var itemMinQuantity = NotFound.itemMinQuantity
    private var itemQuantity = 0.0
    
    
    
    @IBOutlet weak var quantityStepperOutlet: QuantityStepper!
    @IBAction func quantityStepperValueChangedAction(_ sender: QuantityStepper) {
        quantityStepperOutlet.previousValue = itemQuantity
        itemQuantity = quantityStepperOutlet.value
        updateDynamicContent(increasingValues: quantityStepperOutlet.valueIsIncreasing)
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        UIView.transition(
            with: itemImageView,
            duration: 0.5,
            options: [.curveEaseInOut, .transitionFlipFromRight],
            animations: nil,
            completion: nil
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityStepperOutlet.minimumValue = itemMinQuantity[DataManager.Categories.Key.MinQuanityNumber] as? Double ?? 1
        quantityStepperOutlet.stepValue = quantityStepperOutlet.minimumValue
        itemQuantity = quantityStepperOutlet.minimumValue
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
                uoSelf.itemQuantityLabel.text = "\(uoSelf.quantityStepperOutlet.value) \(uoSelf.itemMinQuantity[DataManager.Categories.Key.MinQuantityUnit] as? String ?? "")"
                if (uoSelf.quantityStepperOutlet.value > 1.0) {
                    uoSelf.itemQuantityLabel.text = uoSelf.itemQuantityLabel.text! + "s"
                }
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
