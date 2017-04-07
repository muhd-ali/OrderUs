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
        
        private static let FreshProduceList: List = [
            [
                "Type" : "Fruits",
                "Description" : "Apple, Banana, etc.",
                "ImageURL" : "https://cdn.pixabay.com/photo/2016/04/01/12/20/apple-1300670_960_720.png",
                ],
            [
                "Type" : "Vegetables",
                "Description" : "Potatoes, Onions, etc.",
                "ImageURL" : "https://cdn.pixabay.com/photo/2012/04/13/17/15/vegetables-32932_960_720.png",
                ],
            ]
        
        private static let LaundryList: List = [
            
        ]
        
        private static let GroceryList: List = [
            [
                "Type" : "Fresh Produce",
                "Description" : "Order Pizza, Steak, Burger etc.",
                "ImageURL" : "https://cdn.pixabay.com/photo/2012/04/24/16/09/fruit-40276_960_720.png",
                "Child" : FreshProduceList,
                ],
            [
                "Type" : "Eggs",
                "Description" : "Anday",
                "ImageUrl" : "http://res.freestockphotos.biz/pictures/11/11446-illustration-of-a-white-egg-pv.png",
                ],
            [
                "Type" : "Bread",
                "Description" : "Triple Roti",
                "ImageURL" : "https://cdn.pixabay.com/photo/2012/04/03/14/51/bread-25205_960_720.png",
                ],
        ]
        
        static let MainList: List = [
            [
                "Type" : "Grocery",
                "Description" : "Order Fruits, Vegetables, etc.",
                "ImageURL" : "https://static-s.aa-cdn.net/img/gp/20600004669003/AoNNBeQTIOeAnoUkuWhtAnXbGikpxa1QqwFcmSyQ51DjaBP-K5iU-3b-nbCuaGG6Ur4=w300?v=1",
                "Child" : GroceryList,
                ],
            [
                "Type" : "Laundry",
                "Description" : "Get your stuff washed",
                "ImageURL" : "https://cdn.iconscout.com/public/images/icon/premium/png-256/laundry-plumber-cleaning-electrical-work-3b8d8471053d1179-256x256.png",
                "Child" : LaundryList,
                ],
            ]
    }
}
