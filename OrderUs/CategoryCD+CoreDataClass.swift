//
//  CategoryCD+CoreDataClass.swift
//  OrderUs
//
//  Created by Muhammadali on 09/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import CoreData

@objc(CategoryCD)
public class CategoryCD: NSManagedObject {
    
    class func replaceOrAddCategory(with category: Category, inManagedObjectContext context: NSManagedObjectContext) -> CategoryCD? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryCD")
        request.predicate = NSPredicate(format: "id = %@", category.ID)
        
        if let categoryCD = (try? context.fetch(request))?.first as? CategoryCD {
            context.delete(categoryCD)
        }
        
        if let categoryCD = NSEntityDescription.insertNewObject(forEntityName: "CategoryCD", into: context) as? CategoryCD {
            categoryCD.id = category.ID
            categoryCD.name = category.Name
            categoryCD.imageurl = category.ImageURL
            categoryCD.childrenCategories = category.ChildrenCategories as NSArray
            categoryCD.childrenItems = category.ChildrenItems as NSArray
            categoryCD.parent = category.Parent
            return categoryCD
        }
        
        return nil
    }
    
    class func getCategories(from context: NSManagedObjectContext) -> [Category]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryCD")
        
        if let categoriesCD = (try? context.fetch(request)) as? [CategoryCD] {
            return categoriesCD.map { Category(categoryCD: $0) }
        }
        
        return nil
    }
    
}
