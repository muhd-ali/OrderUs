//
//  Category.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

struct Category: Selectable {
    internal var Name: String
    internal var ImageURL: String
    internal var Parent: String
    internal var ID: String
    var Children: [Selectable]
    var ChildrenCategories: [String]
    var ChildrenItems: [String]
}
