//
//  DataManager.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

class DataManager {
    static let sharedInstance = DataManager()
    
    struct Categories {
        typealias List = [[String: Any]]
        static let Key_Type = "Type"
        static let Key_Description = "Description"
        static let Key_ImageURL = "ImageURL"
        static let Key_Child = "Child"
        
        private static let FreshProduceList: List = [
            [
                Key_Type : "Fruits",
                Key_Description : "Apple, Banana, etc.",
                Key_ImageURL : "https://cdn.pixabay.com/photo/2016/04/01/12/20/apple-1300670_960_720.png",
                ],
            [
                Key_Type : "Vegetables",
                Key_Description : "Potatoes, Onions, etc.",
                Key_ImageURL : "https://cdn.pixabay.com/photo/2012/04/13/17/15/vegetables-32932_960_720.png",
                ],
            ]
        
        private static let LaundryList: List = [
            
        ]
        
        private static let GroceryList: List = [
            [
                Key_Type : "Fresh Produce",
                Key_Description : "Order Pizza, Steak, Burger etc.",
                Key_ImageURL : "https://cdn.pixabay.com/photo/2012/04/24/16/09/fruit-40276_960_720.png",
                Key_Child : FreshProduceList,
                ],
            [
                Key_Type : "Eggs",
                Key_Description : "Anday",
                Key_ImageURL : "http://res.freestockphotos.biz/pictures/11/11446-illustration-of-a-white-egg-pv.png",
                ],
            [
                Key_Type : "Bread",
                Key_Description : "Triple Roti",
                Key_ImageURL : "https://cdn.pixabay.com/photo/2012/04/03/14/51/bread-25205_960_720.png",
                ],
        ]
        
        static let MainList: List = [
            [
                Key_Type : "Grocery",
                Key_Description : "Order Fruits, Vegetables, etc.",
                Key_ImageURL : "https://static-s.aa-cdn.net/img/gp/20600004669003/AoNNBeQTIOeAnoUkuWhtAnXbGikpxa1QqwFcmSyQ51DjaBP-K5iU-3b-nbCuaGG6Ur4=w300?v=1",
                Key_Child : GroceryList,
                ],
            [
                Key_Type : "Laundry",
                Key_Description : "Get your stuff washed",
                Key_ImageURL : "https://cdn.iconscout.com/public/images/icon/premium/png-256/laundry-plumber-cleaning-electrical-work-3b8d8471053d1179-256x256.png",
                Key_Child : LaundryList,
                ],
            ]
    }
}
