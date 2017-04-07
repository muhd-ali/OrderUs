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
            itemPrice = (item?[.Price] as? Int) ?? NotFound.itemPrice
        }
    }
    
    private struct NotFound {
        static let itemName = "no type found"
        static let itemDescription = "no description found"
        static let itemImageURL = "no url found"
        static let itemPrice = -1
        static let itemMinQuantity = {}
    }
    
    private var itemName = NotFound.itemName
    private var itemDescription = NotFound.itemDescription
    private var itemImageURL = NotFound.itemImageURL
    private var itemPrice = NotFound.itemPrice
    private var itemMinQuantity =
    
    
    @IBAction func addQuantityButtons(_ sender: UISegmentedControl) {
    }
    
    @IBAction func addToCartButton(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        itemNameLabel.text = itemName
        itemPriceLabel =
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
