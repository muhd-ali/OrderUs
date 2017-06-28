//
//  Order.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class Order: NSObject {    
    let id = UUID().uuidString
    var items: [OrderedItem] = []
    var userData = UserData.null
    var userDoorStepOption = Preferences.Doorstep.initial.1
    var userPaymentOption = Preferences.Payment.initial.1
    var state: State = .readyToBePlaced
    var timeStamp: TimeStamp?
    var location = DataManager.sharedInstance.orderLocation
    var assignedTo: Rider?
    
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
            "deliveryLocation" : location?.jsonData ?? [:],
        ]
    }
    
    func getItem(withID: String) -> OrderedItem? {
        return items.filter({ $0.item.ID == withID }).first
    }
    
    func removeItem(withID: String) {
        items = items.filter({ $0.item.ID != withID })
    }
    
    func set(item: OrderedItem) {
        removeItem(withID: item.item.ID)
        guard item.quantity.Number > 0 else {
            return
        }
        items.append(item)
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
    
    func updateLocation(to location: OrderLocation) {
        self.location = location
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
