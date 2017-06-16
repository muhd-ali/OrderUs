//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    private let appTintColor = RootCategoriesViewController.Constants.appTintColor
    
    var tableList: [Item] = [] {
        didSet {
            searchResultsController?.tableList = tableList
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ItemDetailsViewController {
            if let tableListIndex = sender as? Int {
                let selected = tableList[tableListIndex]
                dvc.item = selected
                dvc.title = selected.Name
            }
        }
    }
    
    var lastSelectedIndexPath: IndexPath!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedIndexPath = indexPath
        performSegue(withIdentifier: "ItemDetail", sender: indexPath.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        
        let item = tableList[indexPath.row]
        if let itemCell = cell as? ItemsTableViewCell {
            itemCell.item = item
            itemCell.quantityStepperOutlet.stepValue = item.minQuantity.Number
        }
        
        return cell
    }
    
    private func hideSearchBar() {
        let searchBarHeight = 44.0
        if tableView.contentOffset.y == 0.0 {
            tableView.contentOffset = CGPoint(x: 0.0, y: searchBarHeight)
        }
    }
    
    private var searchController: UISearchController!
    private var searchResultsController: SearchResultsTableViewController?
    
    private func initializeSearchController() {
        searchResultsController = storyboard?.instantiateViewController(withIdentifier: "searchResultsController") as? SearchResultsTableViewController
        searchResultsController?.tableList = tableList
        searchResultsController?.parentNavigationController = navigationController
        searchResultsController?.searchController = searchController
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        
        searchController.dimsBackgroundDuringPresentation = true
        let searchBar = searchController.searchBar
        searchBar.barTintColor = appTintColor
        tableView.tableHeaderView = searchBar
        searchBar.sizeToFit()
        hideSearchBar()
    }
    
    // Mark: View Controller Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingToParentViewController {
            initializeSearchController()
            hideSearchBar()
        } else {
            tableView.reloadRows(at: [lastSelectedIndexPath], with: .automatic)
        }
    }
}
