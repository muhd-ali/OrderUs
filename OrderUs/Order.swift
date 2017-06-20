//
//  Order.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
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
    var addressLines: [String]
    var location: CLLocation
    
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

class Order: NSObject {
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
        var quantityValue: Double
        var quantityUnit: String
        
        init(item: Item, quantityValue: Double, quantityUnit: String) {
            self.item = item
            self.quantityValue = quantityValue
            self.quantityUnit = quantityUnit
            super.init()
        }
        
        var jsonData: [String : Any] {
            return [
                "item_id" : item.ID,
                "quanity" : "\(quantityValue) \(quantityUnit)",
            ]
        }
        
        var totalCost: Double {
            return (item.Price / item.minQuantity.Number) * quantityValue
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
    
    let id = UUID().uuidString
    var items: [OrderedItem] = []
    var userData = UserData.null
    var userDoorStepOption = Preferences.Doorstep.initial.1
    var userPaymentOption = Preferences.Payment.initial.1
    var state: State = .readyToBePlaced
    var timeStamp: TimeStamp?
    var location = OrderLocation.null
    
    func promoteState() {
        state = state.nextState()
    }
    
    var jsonData: [String : Any] {
        return [
            "id" : id,
            "items" : items.map { $0.jsonData },
            "userData" : userData.jsonData,
            "userPreferences" : [
                "userDoorStepOption" : userDoorStepOption,
                "userPaymentOption" : userPaymentOption,
            ],
            "deliveryLocation" : location.jsonData,
        ]
    }
    
    func getItem(withID: String) -> OrderedItem? {
        return items.filter({ $0.item.ID == withID }).first
    }
    
    func removeItem(withID: String) {
        items = items.filter({ $0.item.ID != withID })
    }
    
    var totalCost: Double {
        return items.reduce(0) { (result, orderedItem) in
            result + orderedItem.totalCost
        }
    }
    
    var isStarted: Bool {
        return timeStamp != nil
    }
    
    var isAccepted: Bool {
        return timeStamp?.acceptedAt != nil
    }
    
    var isAcknowledged: Bool {
        return timeStamp?.acknowledgedAt != nil
    }
    
    var isDelievered: Bool {
        return timeStamp?.delieveredAt != nil
    }
}

extension Date {
    var shortTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
