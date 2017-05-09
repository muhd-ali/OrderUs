//
//  ShoppingCartModel.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class ShoppingCartModel: NSObject {
    struct Preferences {
        struct Doorstep {
            static let all = [("Ring My Doorbell", "Ring doorbell"), ("Text Me", "Text the customer"), ("Call Me", "Call the customer")]
            static let initial = all[0]
        }
        
        struct Payment {
            static let all = [("On Delivery", "On Delivery"), ("With Credit Card", "With Credit Card")]
            static let initial = all[0]
        }
    }
    
    
    struct OrderedItem {
        var item: Item
        var quantityValue: Double
        var quantityUnit: String
        
        var jsonData: [String : Any] {
            return [
                "item_id" : item.ID,
                "quanity" : "\(quantityValue) \(quantityUnit)",
            ]
        }
        
        func totalCost() -> Double {
            return (item.Price / item.minQuantity.Number) * quantityValue
        }
    }
    
    struct Order {
        var items: [OrderedItem]
        var userData: UserData?
        var userDoorStepOption: String
        var userPaymentOption: String
        
        var jsonData: [String : Any] {
            return [
                "items" : items.map { $0.jsonData },
                "userData" : userData?.jsonData ?? "",
                "userDoorStepOption" : userDoorStepOption,
                "userPaymentOption" : userPaymentOption,
            ]
        }
    }
    
    static let sharedInstance = ShoppingCartModel()
    
    var order = Order(
        items: [],
        userData: SignInModel.sharedInstance.userData,
        userDoorStepOption: Preferences.Doorstep.initial.1,
        userPaymentOption: Preferences.Payment.initial.1
    )
    
}
