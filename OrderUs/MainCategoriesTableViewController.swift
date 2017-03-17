//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class MainCategoriesTableViewController: UITableViewController {
    let mainCategories = DataManager.mainCategories

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mainCategories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)

        let category = mainCategories[indexPath.section]
        if let categoryCell = cell as? CategoriesTableViewCell {
            categoryCell.category = category
        }

        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}
