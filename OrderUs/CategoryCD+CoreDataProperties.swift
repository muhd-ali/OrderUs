//
//  CategoryCD+CoreDataProperties.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-07-11.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import CoreData


extension CategoryCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCD> {
        return NSFetchRequest<CategoryCD>(entityName: "CategoryCD")
    }

    @NSManaged public var childrenCategories: NSArray?
    @NSManaged public var childrenItems: NSArray?
    @NSManaged public var id: String?
    @NSManaged public var imageurl: String?
    @NSManaged public var name: String?
    @NSManaged public var parent: String?

}
