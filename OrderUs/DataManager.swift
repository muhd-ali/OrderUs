//
//  DataManager.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

protocol Selectable {
    var Name: String {get}
    var ImageURL: String {get}
    var Parent: String {get}
    var ID: String {get}
}

protocol DataManagerDelegate {
    func dataChanged(newList: DataManager.ListType)
}

struct Item: Selectable {
    struct MinQuantity {
        static let NumberKey = "number"
        static let UnitKey = "unit"
        let Number: Double
        let Unit: String
        init(rawMinQuantity: [String : Any]) {
            Number = Double(rawMinQuantity[MinQuantity.NumberKey]! as! Int)
            Unit = rawMinQuantity[MinQuantity.UnitKey]! as! String
        }
    }
    internal var Name: String
    internal var ImageURL: String
    internal var Parent: String
    internal var ID: String
    var minQuantity: MinQuantity
    var Price: Double
}

struct Category: Selectable {
    internal var Name: String
    internal var ImageURL: String
    internal var Parent: String
    internal var ID: String
    var Children: [Selectable]
    var ChildrenCategories: [String]
    var ChildrenItems: [String]
}

extension Array where Element: Selectable {
    func filterItemsHelper(selectables: [Selectable], condition: (Item) -> Bool) -> [Item] {
        var items: [Item] = []
        selectables.forEach { selectable in
            if let category = selectable as? Category {
                let innerItems = filterItemsHelper(selectables: category.Children, condition: condition)
                items.append(contentsOf: innerItems)
            } else if let item = selectable as? Item {
                items.append(item)
            }
        }
        return items
    }
    
    func filterItems(condition: (Item) -> Bool) -> [Item] {
        return filterItemsHelper(selectables: self, condition: condition)
    }
}


class DataManager: NSObject {
    typealias ListType = [Selectable]
    static let sharedInstance = DataManager()
    
    var delegate: DataManagerDelegate?
    
    
    internal func makeItem(rawItem:  [String : Any]) -> Item {
        return Item(
            Name: rawItem["Name"]! as! String,
            ImageURL: "\(ServerCommunicator.Constants.serverIP)/\(rawItem["imageURL"]! as! String)".replacingOccurrences(of: " ", with: "%20"),
            Parent: rawItem["Parent"]! as! String,
            ID: rawItem["_id"]! as! String,
            minQuantity: Item.MinQuantity(rawMinQuantity: rawItem["minQuantity"]! as! [String : Any]),
            Price: rawItem["price"]! as! Double
        )
    }
    
    internal func ifDataFetchedFromServerGenerateTree() {
        if itemsLoaded && categoriesLoaded {
            generateCategoryTree()
            itemsLoaded = false
            categoriesLoaded = false
        }
    }
    
    var itemsLoaded = false
    var itemsCooked: [Item] = []
    var itemsRaw: [[String : Any]] = [] {
        didSet {
            itemsCooked = itemsRaw.map { makeItem(rawItem: $0) }
            itemsLoaded = true
            ifDataFetchedFromServerGenerateTree()
        }
    }
    
    internal func makeCategory(rawCategory: [String : Any]) -> Category {
        return Category(
            Name: rawCategory["Name"]! as! String,
            ImageURL: "\(ServerCommunicator.Constants.serverIP)/\(rawCategory["imageURL"]! as! String)".replacingOccurrences(of: " ", with: "%20"),
            Parent: rawCategory["Parent"]! as! String,
            ID: rawCategory["_id"]! as! String,
            Children: [],
            ChildrenCategories: rawCategory["ChildrenCategories"]! as! [String],
            ChildrenItems: rawCategory["ChildrenItems"]! as! [String]
        )
    }
    
    internal func addChildrenCategories(toCategory category: Category, fromList catList: [Category]) -> Category {
        var childrenCategories = catList.filter {category.ChildrenCategories.contains($0.ID)}
        childrenCategories = childrenCategories.map {
            return addChildrenCategories(toCategory: $0, fromList: catList)
        }
        var modifiedCategory = category
        modifiedCategory.Children.append(contentsOf: childrenCategories as [Selectable])
        return modifiedCategory
    }
    
    internal func setupCategories() {
        categoriesCooked = categoriesCooked.map { addChildrenCategories(toCategory: $0, fromList: categoriesCooked) }
        categoriesCooked = categoriesCooked.filter{ $0.Parent == "0" }
    }
    
    internal func setupItems() {
        categoriesCooked = categoriesCooked.map { categoryWithoutChildren in
            var category = categoryWithoutChildren
            let children = itemsCooked.filter { category.ChildrenItems.contains($0.ID) }
            category.Children.append(contentsOf: children as [Selectable])
            return category
        }
    }
    
    internal func generateCategoryTree() {
        setupItems()
        setupCategories()
        delegate?.dataChanged(newList: categoriesCooked)
    }
    
    var categoriesLoaded = false
    var categoriesCooked: [Category] = []
    var categoriesRaw: [[String : Any]] = [] {
        didSet {
            categoriesCooked = categoriesRaw.map { makeCategory(rawCategory: $0) }
            categoriesLoaded = true
            ifDataFetchedFromServerGenerateTree()
        }
    }
    
    struct ExampleCategories {
        internal static let FreshProduceList: ListType = [
            Category(
                Name : "Fruits",
                ImageURL : "https://cdn.pixabay.com/photo/2016/04/01/12/20/apple-1300670.960.720.png",
                Parent : "0",
                ID : "1",
                Children : [],
                ChildrenCategories : [],
                ChildrenItems : []
            ),
            Category(
                Name : "Vegetables",
                ImageURL : "https://cdn.pixabay.com/photo/2012/04/13/17/15/vegetables-32932.960.720.png",
                Parent : "0",
                ID : "2",
                Children : [],
                ChildrenCategories : [],
                ChildrenItems : []
            ),
            ]
        
        internal static let GroceryList: ListType = [
            Category(
                Name : "Fresh Produce",
                ImageURL : "https://cdn.pixabay.com/photo/2012/04/24/16/09/fruit-40276.960.720.png",
                Parent : "0",
                ID : "3",
                Children : FreshProduceList,
                ChildrenCategories : [],
                ChildrenItems : []
            ),
            Item(
                Name : "Eggs",
                ImageURL : "http://res.freestockphotos.biz/pictures/11/11446-illustration-of-a-white-egg-pv.png",
                Parent: "4",
                ID : "1",
                minQuantity : Item.MinQuantity(rawMinQuantity: [Item.MinQuantity.NumberKey : 1, Item.MinQuantity.UnitKey : "dozen"]),
                Price : 120
            ),
            Item(
                Name : "Bread",
                ImageURL : "https://cdn.pixabay.com/photo/2012/04/03/14/51/bread-25205.960.720.png",
                Parent: "4",
                ID : "2",
                minQuantity : Item.MinQuantity(rawMinQuantity: [Item.MinQuantity.NumberKey : 50, Item.MinQuantity.UnitKey : "loaf"]),
                Price : 80.0
            )
        ]
        
        static let MainList: ListType = [
            Category(
                Name : "Grocery",
                ImageURL : "https://static-s.aa-cdn.net/img/gp/20600004669003/AoNNBeQTIOeAnoUkuWhtAnXbGikpxa1QqwFcmSyQ51DjaBP-K5iU-3b-nbCuaGG6Ur4=w300?v=1",
                Parent : "0",
                ID : "4",
                Children : GroceryList,
                ChildrenCategories : [],
                ChildrenItems : []
            ),
            ]
    }
}
