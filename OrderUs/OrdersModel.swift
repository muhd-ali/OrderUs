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
    
    enum OrderState: Int, Comparable {
        case readyToBePlaced,
        unacknowledged,
        receivedByServer,
        receivedByRider,
        delieveredToUser,
        deadState
        
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
        
        static func < (a: OrderState, b: OrderState) -> Bool {
            return a.rawValue < b.rawValue
        }
    }
    
    class Order: NSObject {
        struct TimeStamp {
            var startedAt: Date
            var acceptedAt: Date?
            var completedAt: Date?
        }
        
        var id: String?
        var items: [OrderedItem] = []
        var userData: UserData? = SignInModel.sharedInstance.userData
        var userDoorStepOption: String = Preferences.Doorstep.initial.1
        var userPaymentOption: String = Preferences.Payment.initial.1
        var state: OrderState = .readyToBePlaced
        var timeStamp: TimeStamp?
        
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
    
    var order = Order()
    
    var orders: [Order] = [
        Order()
    ]
    
    private func getOrdersWith(state: OrderState) -> [Order] {
        return orders.filter { $0.state == state }
    }

    private func getOrdersLessThan(state: OrderState) -> [Order] {
        return orders.filter { $0.state < state }
    }

    private func getOrdersExcept(state: OrderState) -> [Order] {
        return orders.filter { $0.state != state }
    }
    
    var unacknowledgedOrders: [Order] {
        return getOrdersWith(state: .unacknowledged)
    }
    
    var pendingOrders: [Order] {
        return getOrdersExcept(state: .delieveredToUser)
    }
    
    var nextOrderCanBePlaced: Bool {
        return unacknowledgedOrders.isEmpty
    }
    
    func orderPlaced() {
        order.timeStamp = Order.TimeStamp(startedAt: Date(), acceptedAt: nil, completedAt: nil)
        orders.append(order)
        order = Order()
    }
}
