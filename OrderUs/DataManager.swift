//
//  DataManager.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    
    struct Categories {
        enum Key {
            case Name
            case Description
            case ImageURL
            case Child
            case MinQuantity
            case Price
            case MinQuanityNumber
            case MinQuantityUnit
        }
        
        typealias CategoryType = [Key: Any]
        typealias ListType = [CategoryType]
        
        private static let FreshProduceList: ListType = [
            [
                .Name : "Fruits",
                .Description : "Apple, Banana, etc.",
                .ImageURL : "https://cdn.pixabay.com/photo/2016/04/01/12/20/apple-1300670.960.720.png",
                ],
            [
                .Name : "Vegetables",
                .Description : "Potatoes, Onions, etc.",
                .ImageURL : "https://cdn.pixabay.com/photo/2012/04/13/17/15/vegetables-32932.960.720.png",
                ],
            ]
        
        private static let LaundryList: ListType = [
            
        ]
        
        private static let GroceryList: ListType = [
            [
                .Name : "Fresh Produce",
                .Description : "Order Pizza, Steak, Burger etc.",
                .ImageURL : "https://cdn.pixabay.com/photo/2012/04/24/16/09/fruit-40276.960.720.png",
                .Child : FreshProduceList,
                ],
            [
                .Name : "Eggs",
                .Description : "Anday",
                .ImageURL : "http://res.freestockphotos.biz/pictures/11/11446-illustration-of-a-white-egg-pv.png",
                .MinQuantity : [Key.MinQuanityNumber : 1, .MinQuantityUnit : "dozen"],
                .Price : 120,
                ],
            [
                .Name : "Bread",
                .Description : "Triple Roti",
                .ImageURL : "https://cdn.pixabay.com/photo/2012/04/03/14/51/bread-25205.960.720.png",
                .MinQuantity : ["number" : 1, "unit" : "unit"],
                .Price : 80,
                ],
        ]
        
        static let MainList: ListType = [
            [
                .Name : "Grocery",
                .Description : "Order Fruits, Vegetables, etc.",
                .ImageURL : "https://static-s.aa-cdn.net/img/gp/20600004669003/AoNNBeQTIOeAnoUkuWhtAnXbGikpxa1QqwFcmSyQ51DjaBP-K5iU-3b-nbCuaGG6Ur4=w300?v=1",
                .Child : GroceryList,
                ],
            [
                .Name : "Laundry",
                .Description : "Get your stuff washed",
                .ImageURL : "https://cdn.iconscout.com/public/images/icon/premium/png-256/laundry-plumber-cleaning-electrical-work-3b8d8471053d1179-256x256.png",
                .Child : LaundryList,
                ],
            ]
    }
}
