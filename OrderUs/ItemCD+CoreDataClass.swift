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
        
        if let itemCD = (try? context.fetch(request))?.first {
            context.delete(itemCD as! NSManagedObject)
        }
        
        if let itemCD = NSEntityDescription.insertNewObject(forEntityName: "ItemCD", into: context) as? ItemCD {
            itemCD.id = item.ID
            itemCD.name = item.Name
            itemCD.imageurl = item.ImageURL
            itemCD.parent = item.Parent
            itemCD.minquantity_number = item.minQuantity.Number
            itemCD.minquantity_unit = item.minQuantity.Unit
            itemCD.price = item.Price
            return itemCD
        }
        
        return nil
    }
    
    class func getItems(from context: NSManagedObjectContext) -> [Item]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCD")
        
        if let itemsCD = (try? context.fetch(request)) as? [ItemCD] {
            return itemsCD.map { itemCD in
                Item(
                    Name: itemCD.name!,
                    ImageURL: itemCD.imageurl!,
                    Parent: itemCD.parent!,
                    ID: itemCD.id!,
                    minQuantity: Item.MinQuantity(number: itemCD.minquantity_number, unit: itemCD.minquantity_unit!),
                    Price: itemCD.price
                )
            }
        }
        
        return nil
    }
    
}
