//
//  DataManager.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

protocol Selectable {
    var Name: String {get}
    var ImageURL: String {get}
    var Parent: String {get}
    var ID: String {get}
}

protocol DataManagerDelegate {
    var dataChangedFunctionCalled: Bool { get }
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
        
        init(number: Double, unit: String) {
            Number = number
            Unit = unit
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

struct SearchResult {
    var item: Item
    var path: [String]
    var attributedPath: NSMutableAttributedString?
}

extension Sequence where Iterator.Element == Selectable {
    private func searchItemsHelper(condition: (Item) -> Bool, path: [String]) -> [SearchResult] {
        var results: [SearchResult] = []
        self.forEach { selectable in
            if let category = selectable as? Category {
                var mutablePath = path
                mutablePath.append(category.Name)
                let innerResults = category.Children.searchItemsHelper(condition: condition, path: mutablePath)
                results.append(contentsOf: innerResults)
            } else if let item = selectable as? Item {
                if condition(item) {
                    var mutablePath = path
                    mutablePath.append(item.Name)
                    let result = SearchResult(item: item, path: mutablePath, attributedPath: nil)
                    results.append(result)
                }
            }
        }
        return results
    }
    
    func searchItems(condition: (Item) -> Bool) -> [SearchResult]  {
        return searchItemsHelper(condition: condition, path: [])
    }
}

struct OrderLocation {
    var addressLines: [String]
    var location: CLLocation
    
    var jsonData: [String: Any] {
        return [
            "addressLines" : addressLines,
            "coordinates" : [
                "latitude" : location.coordinate.latitude,
                "longitude" : location.coordinate.longitude
                ],
        ]
    }
    
    static let null = OrderLocation(addressLines: [], location: CLLocation())
}

class DataManager: NSObject, CLLocationManagerDelegate {
    typealias ListType = [Selectable]
    
    static let sharedInstance = DataManager()
    
    class NullDelegate: DataManagerDelegate {
        var dataChangedFunctionCalled = false
        
        init(called: Bool) {
            dataChangedFunctionCalled = called
        }
        
        func dataChanged(newList: DataManager.ListType) {
            dataChangedFunctionCalled = true
        }
    }
    
    var delegate: DataManagerDelegate = NullDelegate(called: false) {
        didSet {
            if (oldValue as? NullDelegate)?.dataChangedFunctionCalled ?? false {
                delegate.dataChanged(newList: categoryTree)
            }
        }
    }
    
    var managedObjectContext: NSManagedObjectContext?
    
    func bootStrap(dbContext: NSManagedObjectContext) {
        managedObjectContext = dbContext
        loadDataFromDB()
        initLocationService()
    }
    
    private func loadDataFromDB() {
        managedObjectContext?.perform { [unowned uoSelf = self] in
            uoSelf.structuredItems = ItemCD.getItems(from: uoSelf.managedObjectContext!) ?? []
            uoSelf.structuredCategories = CategoryCD.getCategories(from: uoSelf.managedObjectContext!) ?? []
            DispatchQueue.main.async {
                uoSelf.generateCategoryTree()
            }
        }
    }
    
    
    private func makeItem(rawItem:  [String : Any]) -> Item {
        return Item(
            Name: rawItem["Name"]! as! String,
            ImageURL: "\(ServerCommunicator.Constants.serverIP)/\(rawItem["imageURL"]! as! String)".replacingOccurrences(of: " ", with: "%20"),
            Parent: rawItem["Parent"]! as! String,
            ID: rawItem["_id"]! as! String,
            minQuantity: Item.MinQuantity(rawMinQuantity: rawItem["minQuantity"]! as! [String : Any]),
            Price: rawItem["price"]! as! Double
        )
    }
    
    private func ifDataFetchedFromServerGenerateTree() {
        if itemsLoaded && categoriesLoaded {
            generateCategoryTree()
            itemsLoaded = false
            categoriesLoaded = false
        }
    }
    
    private func updateItemsInDB(items: [Item]) {
        managedObjectContext?.perform { [unowned uoSelf = self] in
            items.forEach { item in
                _ = ItemCD.replaceOrAddItem(with: item, inManagedObjectContext: uoSelf.managedObjectContext!)
            }
            do {
                try uoSelf.managedObjectContext?.save()
            } catch let error {
                print ("Core Data Error: \(error.localizedDescription)")
            }
        }
    }
    
    private var itemsLoaded = false
    private var structuredItems: [Item] = []
    var rawItems: [[String : Any]] = [] {
        didSet {
            structuredItems = rawItems.map { makeItem(rawItem: $0) }
            updateItemsInDB(items: structuredItems)
            itemsLoaded = true
            ifDataFetchedFromServerGenerateTree()
        }
    }
    
    private func makeCategory(rawCategory: [String : Any]) -> Category {
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
    
    private func addChildrenCategories(to category: Category, from list: [Category]) -> Category {
        var childrenCategories = list.filter {category.ChildrenCategories.contains($0.ID)}
        childrenCategories = childrenCategories.map {
            return addChildrenCategories(to: $0, from: list)
        }
        var modifiedCategory = category
        modifiedCategory.Children.append(contentsOf: childrenCategories as [Selectable])
        return modifiedCategory
    }
    
    private func reorder(categoriesWithAddedItems: [Category]) -> [Category] {
        let reordered = categoriesWithAddedItems.map { addChildrenCategories(to: $0, from: categoriesWithAddedItems) }
        return reordered.filter{ $0.Parent == "0" }
    }
    
    private func addItems(to categories: [Category]) -> [Category] {
         return categories.map { categoryWithoutChildren in
            var category = categoryWithoutChildren
            let children = structuredItems.filter { item in category.ChildrenItems.contains(item.ID) }
            category.Children.append(contentsOf: children as [Selectable])
            return category
        }
    }
    
    private func freeMemory() {
        rawCategories.removeAll()
        structuredCategories.removeAll()
        rawItems.removeAll()
        structuredItems.removeAll()
    }
    
    var categoryTree: [Selectable] = ExampleCategories.MainList
    private func generateCategoryTree() {
        let categoriesWithAddedItems = addItems(to: structuredCategories)
        categoryTree = reorder(categoriesWithAddedItems: categoriesWithAddedItems)
        //freeMemory()
        delegate.dataChanged(newList: categoryTree)
    }
    
    private func updateCategoriesInDB(categories: [Category]) {
        managedObjectContext?.perform { [unowned uoSelf = self] in
            categories.forEach { category in
                _ = CategoryCD.replaceOrAddCategory(with: category, inManagedObjectContext: uoSelf.managedObjectContext!)
            }
            do {
                try uoSelf.managedObjectContext?.save()
            } catch let error {
                print ("Core Data Error: \(error.localizedDescription)")
            }
        }
    }
    private var categoriesLoaded = false
    private var structuredCategories: [Category] = []
    var rawCategories: [[String : Any]] = [] {
        didSet {
            structuredCategories = rawCategories.map { makeCategory(rawCategory: $0) }
            updateCategoriesInDB(categories: structuredCategories)
            categoriesLoaded = true
            ifDataFetchedFromServerGenerateTree()
        }
    }
    
    var locationManager = CLLocationManager()
    var orderLocation: OrderLocation?
    
    func initLocationService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            CLGeocoder().reverseGeocodeLocation(latestLocation) {[unowned uoSelf = self] (placeMarks, error) in
                if let placeMark = placeMarks?.first {
                    if let address = placeMark.addressDictionary?["FormattedAddressLines"] as? [String] {
                        uoSelf.orderLocation = OrderLocation(addressLines: address, location: latestLocation)
                    }
                }
            }
        }
    }
    
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
