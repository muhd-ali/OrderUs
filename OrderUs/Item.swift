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
        struct Key {
            static let Number = "number"
            static let Unit = "unit"
            static let Price = "price"
        }
        var Number: Double
        let Unit: String
        let Price: Double
        init(rawQuantity: [String : Any]) {
            Number = Double(rawQuantity[Key.Number]! as! Int)
            Unit = rawQuantity[Key.Unit]! as! String
            Price = rawQuantity[Key.Price] as! Double
        }
        
        init(number: Double, unit: String, price: Double) {
            Number = number
            Unit = unit
            Price = price
        }
        
        var costString: String {
            return "PKR \(Price)"
        }
        
        func string1(with units: Double) -> String {
            let amount = Double(units) * Number
            guard amount > 0 else { return "none added" }
            return "\(amount) \(Unit)\(amount == 1 ? "" : "s")"
        }
        
        func string2(with units: Double) -> String {
            let amount = Double(units) * Number
            return "\(amount == 1 ? "each" : "\(amount)") \(Unit)\(amount == 1 ? "" : "s")"
        }
        
        var string1: String {
            return string1(with: 1)
        }
        
        var string2: String {
            return string2(with: 1)
        }
    }
    var minQuantity: Quantity
    
    init(rawItem:  [String : Any]) {
        minQuantity = Item.Quantity(rawQuantity: rawItem["minQuantity"]! as! [String : Any])
        super.init(rawSelectable: rawItem)
    }
    
    init(itemCD: ItemCD) {
        self.minQuantity = Item.Quantity(number: itemCD.minquantity_number, unit: itemCD.minquantity_unit!, price: itemCD.minquantity_price)
        
        let name = itemCD.name!
        let imageURL = itemCD.imageurl!
        let parent = itemCD.parent!
        let id = itemCD.id!
        super.init(Name: name, ImageURL: imageURL, Parent: parent, ID: id)
    }
    
    private weak var orderedItemPrivate: Order.OrderedItem?
    
    private func checkShoppingCart() {
        let currentOrder = OrdersModel.sharedInstance.currentOrder
        let orderedItem = currentOrder.getItem(withID: ID)
        if orderedItem != nil {
            orderedItemPrivate = orderedItem
        } else {
            orderedItemPrivate = nil
        }
    }
    
    var orderedItem: Order.OrderedItem {
        checkShoppingCart()
        if orderedItemPrivate == nil {
            return Order.OrderedItem(item: self)
        } else {
            return orderedItemPrivate!
        }
    }
}
