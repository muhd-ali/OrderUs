//
//  ShoppingCartModel.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class OrdersModel: NSObject {
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
    
    enum OrderState {
        case readyToBePlaced
        case unacknowledged
        case receivedByServer
        case receivedByRider
        case delieveredToUser
        case deadState
        
        func nextState() -> OrderState {
            switch self {
            case .readyToBePlaced:
                return .unacknowledged
            case .unacknowledged:
                return .receivedByServer
            case .receivedByServer:
                return .receivedByRider
            case .receivedByRider:
                return .delieveredToUser
            default:
                return .deadState
            }
        }
    }
    
    class Order: NSObject {
        var id: String
        var items: [OrderedItem]
        var userData: UserData?
        var userDoorStepOption: String
        var userPaymentOption: String
        var state: OrderState
        
        init(id: String, items: [OrderedItem], userData: UserData?, userDoorStepOption: String, userPaymentOption: String, state: OrderState) {
            self.id = id
            self.items = items
            self.userData = userData
            self.userDoorStepOption = userDoorStepOption
            self.userPaymentOption = userPaymentOption
            self.state = state
            super.init()
        }
        
        func promoteState() {
            state = state.nextState()
        }
        
        var jsonData: [String : Any] {
            return [
                "items" : items.map { $0.jsonData },
                "userData" : userData?.jsonData ?? "",
                "userPreferences" : [
                    "userDoorStepOption" : userDoorStepOption,
                    "userPaymentOption" : userPaymentOption,
                ],
            ]
        }
    }
    
    static let sharedInstance = OrdersModel()
    
    var order = Order(
        id: "",
        items: [],
        userData: SignInModel.sharedInstance.userData,
        userDoorStepOption: Preferences.Doorstep.initial.1,
        userPaymentOption: Preferences.Payment.initial.1,
        state: .readyToBePlaced
    )
    
    var orders: [Order] = [
    ]
    
    private func getOrdersWith(state: OrderState) -> [Order] {
        return orders.filter { $0.state == state }
    }
    
    private func getOrdersExcept(state: OrderState) -> [Order] {
        return orders.filter { $0.state != state }
    }
    
    var unacknowledgedOrders: [Order] {
        return getOrdersWith(state: .unacknowledged)
    }
    
    var notYetDelieveredOrders: [Order] {
        return getOrdersExcept(state: .delieveredToUser)
    }
    
    var nextOrderCanBePlaced: Bool {
        return unacknowledgedOrders.isEmpty
    }
    
    func orderPlaced() {
        orders.append(order)
        order = Order(
            id: "",
            items: [],
            userData: SignInModel.sharedInstance.userData,
            userDoorStepOption: Preferences.Doorstep.initial.1,
            userPaymentOption: Preferences.Payment.initial.1,
            state: .readyToBePlaced
        )
    }
}
