//
//  ItemCD+CoreDataClass.swift
//  OrderUs
//
//  Created by Muhammadali on 09/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import CoreData

@objc(ItemCD)
public class ItemCD: NSManagedObject {
    
    class func replaceOrAddItem(with item: Item, inManagedObjectContext context: NSManagedObjectContext) -> ItemCD? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCD")
        request.predicate = NSPredicate(format: "id = %@", item.ID)
        
        if let itemCD = (try? context.fetch(request))?.first as? ItemCD {
            context.delete(itemCD)
        }
        
        if let itemCD = NSEntityDescription.insertNewObject(forEntityName: "ItemCD", into: context) as? ItemCD {
            itemCD.id = item.ID
            itemCD.name = item.Name
            itemCD.imageurl = item.ImageURL
            itemCD.parent = item.Parent
            itemCD.minquantity_number = item.minQuantity.Number
            itemCD.minquantity_unit = item.minQuantity.Unit
            itemCD.minquantity_price = item.minQuantity.Price
            return itemCD
        }
        
        return nil
    }
    
    class func getItems(from context: NSManagedObjectContext) -> [Item]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCD")
        
        if let itemsCD = (try? context.fetch(request)) as? [ItemCD] {
            return itemsCD.map { Item(itemCD: $0) }
        }
        
        return nil
    }
    
}
