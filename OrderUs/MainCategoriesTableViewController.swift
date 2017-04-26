//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class MainCategoriesTableViewController: UITableViewController {
    var parentList: [DataManager.ListType] = []
    var pageTitles: [String] = []
    var userIsForwardNavigating = true
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBAction func backButtonAction(_ sender: UIButton) {
        userIsForwardNavigating = false
        tableList = parentList.removeLast()
        title = pageTitles.removeLast()
    }
    
    private func getTransitionEffect() -> UIViewAnimationOptions {
        if userIsForwardNavigating {
            return .transitionFlipFromRight
        } else {
            return .transitionFlipFromLeft
        }
    }
    
    private var tableList = DataManager.ExampleCategories.MainList {
        didSet {
            let transitionEffect = getTransitionEffect()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ItemDetailsViewController {
            if let tableListIndex = sender as? Int {
                dvc.item = tableList[tableListIndex] as? DataManager.Item
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableList[indexPath.section]
        if let newTableList = (selected as? DataManager.Category)?.Children {
            userIsForwardNavigating = true
            
            pageTitles.append(title!)
            title = selected.Name
            
            parentList.append(tableList)
            tableList = newTableList
        } else {
            performSegue(withIdentifier: "ItemDetail", sender: indexPath.section)
        }
    }
    
    func setBackButtonVisibility() {
        if parentList.count == 0 {
            backButtonOutlet.isHidden = true
        } else {
            backButtonOutlet.isHidden = false
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        setBackButtonVisibility()
        return tableList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        
        let category = tableList[indexPath.section]
        if let categoryCell = cell as? CategoriesTableViewCell {
            categoryCell.category = category
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        title = "Categories"
    }
    
    @IBOutlet weak var shoppingCartOutlet: MIBadgeButton!
    
    func setShoppingCartBadgeAppearance() {
        let cartItemsCount = ShoppingCartModel.sharedInstance.cartItems.count
        
        if cartItemsCount > 0 {
            shoppingCartOutlet.badgeString = "\(cartItemsCount)"
        } else {
            shoppingCartOutlet.badgeString = nil
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setShoppingCartBadgeAppearance()
    }
}
