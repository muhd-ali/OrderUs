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
        static let Layer2FreshProduce: [[String: Any]] = [
            [
                "Type" : "Fruits",
                "Examples" : "Apple, Banana, etc.",
                "image" : "https://cdn.pixabay.com/photo/2016/04/01/12/20/apple-1300670_960_720.png",
                ],
            [
                "Type" : "Vegetables",
                "Examples" : "Potatoes, Onions, etc.",
                "image" : "https://cdn.pixabay.com/photo/2012/04/13/17/15/vegetables-32932_960_720.png",
                ],
            ]
        
        static let Layer2Laundry: [[String: Any]] = [
            
        ]
        
        static let Layer2Grocery: [[String: Any]] = [
            [
                "Type" : "Eggs",
                "Examples" : "Anday",
                "image" : "http://res.freestockphotos.biz/pictures/11/11446-illustration-of-a-white-egg-pv.png",
                ],
            [
                "Type" : "Bread",
                "Examples" : "Triple Roti",
                "image" : "https://cdn.pixabay.com/photo/2012/04/03/14/51/bread-25205_960_720.png",
                ],
        ]
        
        static let Layer1: [[String: Any]] = [
            [
                "Type" : "Fresh Produce",
                "Examples" : "Order Pizza, Steak, Burger etc.",
                "image" : "https://cdn.pixabay.com/photo/2012/04/24/16/09/fruit-40276_960_720.png",
                "child" : Layer2FreshProduce,
                ],
            [
                "Type" : "Laundry",
                "Examples" : "Get your stuff washed",
                "image" : "https://cdn.iconscout.com/public/images/icon/premium/png-256/laundry-plumber-cleaning-electrical-work-3b8d8471053d1179-256x256.png",
                "child" : Layer2Laundry,
                ],
            [
                "Type" : "Grocery",
                "Examples" : "Order Fruits, Vegetables, etc.",
                "image" : "https://static-s.aa-cdn.net/img/gp/20600004669003/AoNNBeQTIOeAnoUkuWhtAnXbGikpxa1QqwFcmSyQ51DjaBP-K5iU-3b-nbCuaGG6Ur4=w300?v=1",
                "child" : Layer2Grocery,
                ],
            ]
    }
}
