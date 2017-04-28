//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift

class MainCategoriesTableViewController: UITableViewController, DataManagerDelegate {
    func dataChanged(newList: DataManager.ListType) {
        tableList = newList
    }
    
    private var tableList: DataManager.ListType = DataManager.sharedInstance.categoriesCooked {
//    private var tableList: DataManager.ListType = DataManager.ExampleCategories.MainList {
        didSet {
            UIView.transition(
                with: tableView,
                duration: 0.5,
                options: [.transitionCrossDissolve, .curveEaseInOut],
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
                let selected = tableList[tableListIndex] as! DataManager.Item
                dvc.item = selected
                dvc.title = selected.Name
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableList[indexPath.section]
        if let newTableList = (selected as? DataManager.Category)?.Children {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainCategoriesController") as! MainCategoriesTableViewController
            vc.tableList = newTableList
            vc.title = selected.Name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            performSegue(withIdentifier: "ItemDetail", sender: indexPath.section)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
        DataManager.sharedInstance.delegate = self
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
