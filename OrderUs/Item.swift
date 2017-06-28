//
//  Item.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class Item: Selectable {
    struct Quantity {
        static let NumberKey = "number"
        static let UnitKey = "unit"
        var Number: Double
        let Unit: String
        init(rawQuantity: [String : Any]) {
            Number = Double(rawQuantity[Quantity.NumberKey]! as! Int)
            Unit = rawQuantity[Quantity.UnitKey]! as! String
        }
        init(number: Double, unit: String) {
            Number = number
            Unit = unit
        }
        var string1: String {
            return "\(Number) \(Unit)\(Number == 1 ? "" : "s")"
        }
        
        var string2: String {
            return "\(Number == 1 ? "each" : "\(Number)") \(Unit)\(Number == 1 ? "" : "s")"
        }
    }
    var minQuantity: Quantity
    var Price: Double
    
    init(rawItem:  [String : Any]) {
        minQuantity = Item.Quantity(rawQuantity: rawItem["minQuantity"]! as! [String : Any])
        Price = rawItem["price"]! as! Double
        super.init(rawSelectable: rawItem)
    }
    
    init(itemCD: ItemCD) {
        self.minQuantity = Item.Quantity(number: itemCD.minquantity_number, unit: itemCD.minquantity_unit!)
        self.Price = itemCD.price
        
        let name = itemCD.name!
        let imageURL = itemCD.imageurl!
        let parent = itemCD.parent!
        let id = itemCD.id!
        super.init(Name: name, ImageURL: imageURL, Parent: parent, ID: id)
    }
    
    private var isInShoppingCartPrivate: Bool?
    var orderedItem: Order.OrderedItem?
    
    private func checkShoppingCart() {
        let orderedItems = OrdersModel.sharedInstance.currentOrder.items.filter { $0.item.ID == ID }
        if !orderedItems.isEmpty {
            isInShoppingCartPrivate = true
            orderedItem = orderedItems.first
        } else {
            isInShoppingCartPrivate = false
        }
    }
    
    var isInShoppingCart: Bool {
        if isInShoppingCartPrivate == nil {
            checkShoppingCart()
        }
        return isInShoppingCartPrivate!
    }
}
