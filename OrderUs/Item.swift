//
//  Item.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

struct Item: Selectable {
    struct Quantity {
        static let NumberKey = "number"
        static let UnitKey = "unit"
        var Number: Double
        let Unit: String
        init(rawQuantity: [String : Any]) {
            Number = Double(rawQuantity[Quantity.NumberKey]! as! Int)
            Unit = rawQuantity[Quantity.UnitKey]! as! String
        }
        init(number: Double, unit: String) {
            Number = number
            Unit = unit
        }
        var string1: String {
            return "\(Number) \(Unit)\(Number == 1 ? "" : "s")"
        }

        var string2: String {
            return "\(Number == 1 ? "each" : "\(Number)") \(Unit)\(Number == 1 ? "" : "s")"
        }
}
    internal var Name: String
    internal var ImageURL: String
    internal var Parent: String
    internal var ID: String
    var minQuantity: Quantity
    var Price: Double
}
