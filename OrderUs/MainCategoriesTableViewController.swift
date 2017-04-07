//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class MainCategoriesTableViewController: UITableViewController {
    var parentList: [DataManager.Categories.List] = []
    var userIsForwardNavigating = true

    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBAction func backButtonAction(_ sender: UIButton) {
        userIsForwardNavigating = false
        tableList = parentList.removeLast()
    }
    
    var tableList = DataManager.Categories.MainList {
        didSet {
            var transitionEffect: UIViewAnimationOptions
            if userIsForwardNavigating {
                transitionEffect = .transitionFlipFromRight
                parentList.append(oldValue)
            } else {
                transitionEffect = .transitionFlipFromLeft
            }
            
            UIView.transition(
                with: tableView,
                duration: 0.5,
                options: [transitionEffect, .curveEaseInOut],
                animations: { [weak weakSelf = self] in
                    weakSelf?.tableView.reloadData()
                },
                completion: nil
            )
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableList[indexPath.row]
        if let newTableList = selected["Child"] as? DataManager.Categories.List {
            userIsForwardNavigating = true
            tableList = newTableList
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if parentList.count == 0 {
            backButtonOutlet.isHidden = true
        } else {
            backButtonOutlet.isHidden = false
        }
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
