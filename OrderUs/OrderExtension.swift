//
//  OrderFields.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-21.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import CoreLocation

extension Sequence where Iterator.Element == Order {
    private func orders(with state: Order.State) -> [Order] {
        return self.filter { $0.state == state }
    }
    
    private func orders(except state: Order.State) -> [Order] {
        return self.filter { $0.state != state }
    }
    
    var unacknowledged: [Order] {
        return orders(with: .unacknowledged)
    }
    
    var pending: [Order] {
        return orders(except: .delieveredToUser)
    }
}

struct OrderLocation {
    let addressLines: [String]
    let location: CLLocation
    var address: String {
        let string = addressLines.reduce("") { (result, address) in
            if result.isEmpty {
                return address
            } else {
                return result + "\n" + address
            }
        }
        print("address: -->\(string)")
        return string
    }
    var jsonData: [String: Any] {
        return [
            "addressLines" : addressLines,
            "coordinates" : [
                "latitude" : location.coordinate.latitude,
                "longitude" : location.coordinate.longitude
            ],
        ]
    }
    
    static let null = OrderLocation(addressLines: [], location: CLLocation())
}

extension Order {
    struct Rider {
        let name: String
        let phoneNumber: String
    }
    
    enum State: Int, Comparable {
        case readyToBePlaced,
        unacknowledged,
        receivedByServer,
        receivedByRider,
        delieveredToUser,
        deadState
        
        func nextState() -> State {
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
        
        static func < (a: State, b: State) -> Bool {
            return a.rawValue < b.rawValue
        }
    }
    
    class OrderedItem: NSObject {
        var item: Item
        var quantity: Item.Quantity
        
        init(item: Item, quantity: Double) {
            self.item = item
            self.quantity = item.minQuantity
            self.quantity.Number = quantity
            super.init()
        }
        
        var jsonData: [String : Any] {
            return [
                "item_id" : item.ID,
                "quanity" : ["number" : quantity.Number, "unit" : quantity.Unit],
            ]
        }
        
        var totalCost: Double {
            return (item.Price / item.minQuantity.Number) * quantity.Number
        }
    }
    
    struct Preferences {
        struct Doorstep {
            static let all = [("Ring My Doorbell", "Ring doorbell"), ("Text Me", "Text the customer"), ("Call Me", "Call the customer")]
            static let initial = all[0]
        }
        
        struct Payment {
            static let all = [("With Cash On Delivery", "With Cash On Delivery"), ("With Credit Card", "With Credit Card")]
            static let initial = all[0]
        }
    }
    
    struct TimeStamp {
        var startedAt: Date
        var acknowledgedAt: Date?
        var acceptedAt: Date?
        var delieveredAt: Date?
    }
}
