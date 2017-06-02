//
//  MiddleCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 02/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class MiddleCategoriesTableViewController: UITableViewController, DataManagerDelegate {
    
    var dataChangedFunctionCalled: Bool = false
    func dataChanged(newList: [Category]) {
        categories = newList
        dataChangedFunctionCalled = true
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.delegate = self
    }
    
    var categories: [Category] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories[section].ChildrenCategories.count > 0 {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCategoryCell")
        print("getting header")
        if let categoryCell = cell as? MiddleCategoriesTableViewCell {
            categoryCell.category = categories[section]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCategoryCollection", for: indexPath)
            if let categoriesCell = cell as? BottomCategoriesTableViewCell {
                categoriesCell.categories = categories[indexPath.section].Children.categories()
            }
        }
        return cell
    }
    
}
