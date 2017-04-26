//
//  ShoppingCartModel.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class ShoppingCartModel: NSObject {
    
    struct OrderedItem {
        var item: DataManager.Item
        var quantityValue: Double
        var quantityUnit: String
        
        var jsonData: [String : String] {
            return [
                "item_id" : item.ID,
                "quanity" : "\(quantityValue) \(quantityUnit)"
            ]
        }
    }
    
    static let sharedInstance = ShoppingCartModel()
    
    var cartItems: [OrderedItem] = []
    
}
