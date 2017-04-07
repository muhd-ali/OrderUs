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
            itemQuantity = itemMinQuantity
        }
    }
    
    private struct NotFound {
        static let itemName = "no type found"
        static let itemDescription = "no description found"
        static let itemImageURL = "no url found"
        static let itemPrice = -1.0
        static let itemMinQuantity = Dictionary<DataManager.Categories.Key,Any>()
    }
    
    private var itemName = NotFound.itemName
    private var itemDescription = NotFound.itemDescription
    private var itemImageURL = NotFound.itemImageURL
    private var itemPrice = NotFound.itemPrice
    private var itemMinQuantity = NotFound.itemMinQuantity
    private var itemQuantity = NotFound.itemMinQuantity
    
    

    @IBOutlet weak var quantityStepperOutlet: UIStepper!
    @IBAction func quantityStepperValueChangedAction(_ sender: UIStepper) {
        updateDynamicContent()
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quantityStepperOutlet.minimumValue = itemMinQuantity[DataManager.Categories.Key.MinQuanityNumber] as? Double ?? 1
        quantityStepperOutlet.stepValue = quantityStepperOutlet.minimumValue
        updateUI()
    }
    
    private func updateUI() {
        itemNameLabel.text = itemName
        updateImage()
        updateDynamicContent()
    }
    
    private func updateDynamicContent() {
        itemQuantityLabel.text = "\(quantityStepperOutlet.value) \(itemMinQuantity[DataManager.Categories.Key.MinQuantityUnit] as? String ?? "")"
        itemPriceLabel.text = "\((itemPrice/quantityStepperOutlet.minimumValue) * quantityStepperOutlet.value) PKR"
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
