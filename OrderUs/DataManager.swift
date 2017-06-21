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

protocol DataManagerDelegate {
    var dataChangedFunctionCalled: Bool { get }
    func dataChanged(newList: [Category])
}

class DataManager: NSObject {
    typealias ListType = [Selectable]
    
    static let sharedInstance = DataManager()
    
    class NullDelegate: DataManagerDelegate {
        var dataChangedFunctionCalled = false
        
        init(called: Bool) {
            dataChangedFunctionCalled = called
        }
        
        func dataChanged(newList: [Category]) {
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
            minQuantity: Item.Quantity(rawQuantity: rawItem["minQuantity"]! as! [String : Any]),
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
    
    var categoryTree = [Category]()
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
}

extension DataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            CLGeocoder().reverseGeocodeLocation(latestLocation) {[unowned uoSelf = self] (placeMarks, error) in
                if let placeMark = placeMarks?.first {
                    if let address = placeMark.addressDictionary?["FormattedAddressLines"] as? [String] {
                        uoSelf.orderLocation = OrderLocation(addressLines: address, location: latestLocation)
                        OrdersModel.sharedInstance.currentOrder.updateLocation(to: uoSelf.orderLocation!)
                    }
                }
            }
        }
    }
}
