//
//  ItemCD+CoreDataProperties.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-07-11.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import CoreData


extension ItemCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemCD> {
        return NSFetchRequest<ItemCD>(entityName: "ItemCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageurl: String?
    @NSManaged public var minquantity_number: Double
    @NSManaged public var minquantity_unit: String?
    @NSManaged public var name: String?
    @NSManaged public var parent: String?
    @NSManaged public var minquantity_price: Double

}
