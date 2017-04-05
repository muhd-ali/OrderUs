//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class MainCategoriesTableViewController: UITableViewController {
    var parentList: [[String:Any]]?

    @IBAction func backButton(_ sender: UIButton) {
        tableList = parentList!
    }
    
    var tableList = DataManager.Categories.Layer1 {
        didSet {
            UIView.transition(
                with: tableView,
                duration: 0.75,
                options: [.transitionFlipFromRight, .curveEaseInOut],
                animations: { [weak weakSelf = self] in
                    weakSelf?.tableView.reloadData()
                },
                completion: nil
            )
            parentList = oldValue
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableList[indexPath.row]
        if let newTableList = selected["child"] as? [[String:Any]] {
            tableList = newTableList
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        
        let category = tableList[indexPath.row]
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
