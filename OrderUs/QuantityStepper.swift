//
//  QuantityStepper.swift
//  OrderUs
//
//  Created by Muhammadali on 09/04/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import GMStepper

class QuantityStepper: UIStepper {
    var previousValue: Double? {
        didSet {
            if (previousValue != nil) {
                if (value > previousValue!) {
                    valueIsIncreasing = true
                } else {
                    valueIsIncreasing = false
                }
            }
        }
    }
    var valueIsIncreasing = true
}

extension GMStepper {
    func valueIsIncreasing(previousValue: Double) -> Bool {
        if (value > previousValue) {
            return true
        } else {
            return false
        }
    }
}
