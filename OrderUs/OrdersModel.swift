//
//  ShoppingCartModel.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-12.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class OrdersModel: NSObject {
    static let sharedInstance = OrdersModel()
    
    var currentOrder = Order()
    
    var placedOrders: [Order] = [
        Order(),
        Order(),
    ]
    
    var nextOrderCanBePlaced: Bool {
        return placedOrders.unacknowledged.isEmpty
    }
    
    func lastOrderAcknowledged() {
        placedOrders.unacknowledged.first?.promoteState()
    }
    
    enum PlaceOrderResult {
        case success, notSignedIn, noLocationFound, pendingOrderInQueue
    }
    
    func placeOrder() -> PlaceOrderResult {
//        guard OrdersModel.sharedInstance.nextOrderCanBePlaced else { return .pendingOrderInQueue }
//        let signInModel = SignInModel.sharedInstance
//        if let userData = signInModel.userData, signInModel.signedIn {
//            if userData.email != nil {
//                currentOrder.userData = userData
//                if let location = DataManager.sharedInstance.orderLocation {
//                    currentOrder.location = location
        
                    ServerCommunicator.sharedInstance.placeOrder()
                    return .success
//                }
//                return .noLocationFound
//            }
//        }
//        return .notSignedIn
    }
    
    func orderPlaced() {
        currentOrder.timeStamp = Order.TimeStamp(startedAt: Date(), acknowledgedAt: nil, acceptedAt: nil, delieveredAt: nil)
        placedOrders.append(currentOrder)
        currentOrder = Order()
    }
}
