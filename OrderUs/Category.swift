//
//  Category.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class Category: Selectable {
    var Children: [Selectable] = []
    let ChildrenCategories: [String]
    let ChildrenItems: [String]
    
    init(rawCategory: [String : Any]) {
        ChildrenCategories = rawCategory["ChildrenCategories"]! as! [String]
        ChildrenItems = rawCategory["ChildrenItems"]! as! [String]
        super.init(rawSelectable: rawCategory)
    }
    
    init(categoryCD: CategoryCD) {
        ChildrenCategories = categoryCD.childrenCategories as? [String] ?? []
        ChildrenItems = categoryCD.childrenItems as? [String] ?? []
        
        let name = categoryCD.name!
        let imageURL = categoryCD.imageurl!
        let parent = categoryCD.parent!
        let id = categoryCD.id!
        super.init(Name: name, ImageURL: imageURL, Parent: parent, ID: id)
    }
    
    var containsItems: Bool {
       return ChildrenCategories.isEmpty
    }
    
    func contains(item: Item) -> Bool {
        return ChildrenItems.contains(item.ID)
    }

    func contains(category: Category) -> Bool {
        return ChildrenCategories.contains(category.ID)
    }

    internal func addChildren(from list: [Category]) -> Category {
        let childrenCategories = list.filter { self.contains(category: $0) }
        let modifiedCategory = self
        modifiedCategory.Children.append(contentsOf: childrenCategories as [Selectable])
        return modifiedCategory
    }
}

extension Sequence where Iterator.Element == Category {
    func addChildren(items: [Item]) -> [Category] {
        return self.map { categoryWithoutChildren in
            let category = categoryWithoutChildren
            let children = items.filter { category.contains(item: $0) }
            category.Children.append(contentsOf: children as [Selectable])
            return category
        }
    }
    
    func setOrder() -> [Category] {
        let reordered = self.map { $0.addChildren(from: self as! [Category]) }
        return reordered.filter{ $0.Parent == "0" }
    }
}
