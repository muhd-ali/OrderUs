//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController, DataManagerDelegate {
    func dataChanged(newList: DataManager.ListType) {
        tableList = newList
    }
    
    var tableList: DataManager.ListType = [] {
        didSet {
            UIView.transition(
                with: tableView,
                duration: 0.5,
                options: [.transitionCrossDissolve, .curveEaseInOut],
                animations: { [unowned uoSelf = self] in
                    uoSelf.tableView.reloadData()
                },
                completion: nil
            )
            
            resultsController?.tableList = tableList
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ItemDetailsViewController {
            if let tableListIndex = sender as? Int {
                let selected = tableList[tableListIndex] as! Item
                dvc.item = selected
                dvc.title = selected.Name
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let selected = tableList[indexPath.row]
            if let newTableList = (selected as? Category)?.Children {
                let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesController") as! CategoriesTableViewController
                vc.tableList = newTableList
                vc.title = selected.Name
                navigationController?.pushViewController(vc, animated: true)
            } else {
                performSegue(withIdentifier: "ItemDetail", sender: indexPath.row)
            }
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        switch section {
        case 0:
            rows = tableList.count
        default:
            break
        }
        
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
            
            let category = tableList[indexPath.row]
            if let categoryCell = cell as? CategoriesTableViewCell {
                categoryCell.category = category
            }
        default:
            break
        }
        
        return cell
    }
    
    private func hideSearchBar() {
        let searchBarHeight = 44.0
        if tableView.contentOffset.y == 0.0 {
            tableView.contentOffset = CGPoint(x: 0.0, y: searchBarHeight)
        }
    }
    
    var searchController: UISearchController!
    var resultsController: SearchResultsTableViewController?
    
    private func initializeSearchController() {
        resultsController = storyboard?.instantiateViewController(withIdentifier: "searchResultsController") as? SearchResultsTableViewController
        resultsController?.tableList = tableList
        resultsController?.parentNavigationController = navigationController
        resultsController?.searchController = searchController
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // Mark: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSearchController()
        DataManager.sharedInstance.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideSearchBar()
    }
}
