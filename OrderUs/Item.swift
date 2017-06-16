//
//  Item.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

struct Item: Selectable {
    struct MinQuantity {
        static let NumberKey = "number"
        static let UnitKey = "unit"
        let Number: Double
        let Unit: String
        init(rawMinQuantity: [String : Any]) {
            Number = Double(rawMinQuantity[MinQuantity.NumberKey]! as! Int)
            Unit = rawMinQuantity[MinQuantity.UnitKey]! as! String
        }
        
        init(number: Double, unit: String) {
            Number = number
            Unit = unit
        }
    }
    internal var Name: String
    internal var ImageURL: String
    internal var Parent: String
    internal var ID: String
    var minQuantity: MinQuantity
    var Price: Double
}
