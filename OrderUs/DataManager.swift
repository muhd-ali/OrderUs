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
    var Description: String {get}
    var ImageURL: String {get}
}

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    
    struct Item: Selectable {
        enum MinQuantityKey {
            case Number
            case Unit
        }
        internal var Name: String
        internal var Description: String
        internal var ImageURL: String
        var MinQuantity: [MinQuantityKey : Any]
        var Price: Double
        var ID: String
    }
    
    struct Category: Selectable {
        internal var Name: String
        internal var Description: String
        internal var ImageURL: String
        var Children: [Selectable]
    }
    
    typealias ListType = [Selectable]
    
    struct ExampleCategories {
        private static let FreshProduceList: ListType = [
            Category(
                Name : "Fruits",
                Description : "Apple, Banana, etc.",
                ImageURL : "https://cdn.pixabay.com/photo/2016/04/01/12/20/apple-1300670.960.720.png",
                Children : []
            ),
            Category(
                Name : "Vegetables",
                Description : "Potatoes, Onions, etc.",
                ImageURL : "https://cdn.pixabay.com/photo/2012/04/13/17/15/vegetables-32932.960.720.png",
                Children : []
            ),
            ]
        
        private static let LaundryList: ListType = [
            
        ]
        
        private static let GroceryList: ListType = [
            Category(
                Name : "Fresh Produce",
                Description : "Order Pizza, Steak, Burger etc.",
                ImageURL : "https://cdn.pixabay.com/photo/2012/04/24/16/09/fruit-40276.960.720.png",
                Children : FreshProduceList
            ),
            Item(
                Name : "Eggs",
                Description : "Anday",
                ImageURL : "http://res.freestockphotos.biz/pictures/11/11446-illustration-of-a-white-egg-pv.png",
                MinQuantity : [.Number : 1, .Unit : "dozen"],
                Price : 120,
                ID : "egg"
            ),
            Item(
                Name : "Bread",
                Description : "Triple Roti",
                ImageURL : "https://cdn.pixabay.com/photo/2012/04/03/14/51/bread-25205.960.720.png",
                MinQuantity : [.Number  : 1, .Unit : "unit"],
                Price : 80.0,
                ID : "bread" 
            )
        ]
        
        static let MainList: ListType = [
            Category(
                Name : "Grocery",
                Description : "Order Fruits, Vegetables, etc.",
                ImageURL : "https://static-s.aa-cdn.net/img/gp/20600004669003/AoNNBeQTIOeAnoUkuWhtAnXbGikpxa1QqwFcmSyQ51DjaBP-K5iU-3b-nbCuaGG6Ur4=w300?v=1",
                Children : GroceryList
            ),
            Category(
                Name : "Laundry",
                Description : "Get your stuff washed",
                ImageURL : "https://cdn.iconscout.com/public/images/icon/premium/png-256/laundry-plumber-cleaning-electrical-work-3b8d8471053d1179-256x256.png",
                Children : LaundryList
            )
        ]
    }
}
