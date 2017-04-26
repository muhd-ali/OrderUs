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

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    
    struct Item: Selectable {
        struct MinQuantityKey {
            static let Number = "number"
            static let Unit = "unit"
        }
        internal var Name: String
        internal var ImageURL: String
        internal var Parent: String
        internal var ID: String
        var MinQuantity: [String : Any]
        var Price: Double
    }
    
    var itemsCooked: [Item] = []
    var itemsRaw: [[String : Any]] = [] {
        didSet {
            itemsCooked = itemsRaw.map { item in
                Item(
                    Name: item["Name"]! as! String,
                    ImageURL: "\(ServerCommunicator.Constants.serverIP)\\\(item["imageURL"]! as! String)",
                    Parent: item["Parent"]! as! String,
                    ID: item["_id"]! as! String,
                    MinQuantity: item["minQuantity"]! as! [String : Any],
                    Price: item["price"]! as! Double
                )
            }
        }
    }
    
    private func makeCategory(rawCategory: [String : Any]) -> Category {
        return Category(
            Name: rawCategory["Name"]! as! String,
            ImageURL: "\(ServerCommunicator.Constants.serverIP)\\\(rawCategory["imageURL"]! as! String)",
            Parent: rawCategory["Parent"]! as! String,
            ID: rawCategory["_id"]! as! String,
            Children: [],
            ChildrenCategories: rawCategory["ChildrenCategories"]! as! [String],
            ChildrenItems: rawCategory["ChildrenItems"]! as! [String]
        )
    }
    var categoriesCooked: [Category] = []
    var categoriesRaw: [[String : Any]] = [] {
        didSet {
            categoriesCooked = categoriesRaw
                .map { makeCategory(rawCategory: $0) }
            
            categoriesCooked = categoriesCooked.map { tempCat0 in
                var category = tempCat0
                let children = categoriesCooked.filter({ tempCat1 in true })
                category.Children.append(contentsOf: children as [Selectable])
                return category
            }
        }
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
    
    typealias ListType = [Selectable]
    
    struct ExampleCategories {
        private static let FreshProduceList: ListType = [
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
        
        private static let GroceryList: ListType = [
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
                MinQuantity : [Item.MinQuantityKey.Number : 1, Item.MinQuantityKey.Unit : "dozen"],
                Price : 120
            ),
            Item(
                Name : "Bread",
                ImageURL : "https://cdn.pixabay.com/photo/2012/04/03/14/51/bread-25205.960.720.png",
                Parent: "4",
                ID : "2",
                MinQuantity : [Item.MinQuantityKey.Number : 1, Item.MinQuantityKey.Unit : "unit"],
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
