//
//  ItemCD+CoreDataProperties.swift
//  OrderUs
//
//  Created by Muhammadali on 09/05/2017.
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
    @NSManaged public var price: Double
    @NSManaged public var parent: String?

}
