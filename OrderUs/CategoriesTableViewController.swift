//
//  MainCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController, DataManagerDelegate, UISearchResultsUpdating {
    func dataChanged(newList: DataManager.ListType) {
        tableList = newList
    }
    
//    internal var tableList: DataManager.ListType = DataManager.sharedInstance.categoriesCooked {
    internal var tableList: DataManager.ListType = DataManager.ExampleCategories.MainList {
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
    
    internal var titleToDisplay = ""
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableList[indexPath.section]
        if let newTableList = (selected as? DataManager.Category)?.Children {
            let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesController") as! CategoriesTableViewController
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
    
    internal func hideSearchBar() {
        let searchBarHeight = 44.0
        if tableView.contentOffset.y == 0.0 {
            tableView.contentOffset = CGPoint(x: 0.0, y: searchBarHeight)
        }
    }
    
    // Search Bar Operations
    internal func findSearchResults(fromList list: DataManager.ListType, listPath: String, withSearchedText text: String) -> [SearchResultsTableViewController.SearchResult] {
        let jaggedResults:[[SearchResultsTableViewController.SearchResult]] = list.map { listItem in
            var foundResults: [SearchResultsTableViewController.SearchResult] = []
            if let category = listItem as? DataManager.Category {
                foundResults = findSearchResults(fromList: category.Children, listPath: "\(listPath) -> \(category.Name)", withSearchedText: text)
            } else if let item = listItem as? DataManager.Item {
                if (!text.isEmpty) {
                    let range = item.Name.range(of: text)
                    if range != nil {
                        foundResults.append(SearchResultsTableViewController.SearchResult(item: item, path: "\(listPath) -> \(item.Name)"))
                    }
                }
            }
            return foundResults
        }
        return jaggedResults.flatMap { $0 }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchedText = searchController.searchBar.text {
            resultsController?.results = findSearchResults(fromList: tableList, listPath: "list", withSearchedText: searchedText)
            resultsController?.tableView.reloadData()
        }
    }
    
    var searchController: UISearchController!
    var resultsController: SearchResultsTableViewController?
    
    internal func initializeSearchController() {
        resultsController = storyboard?.instantiateViewController(withIdentifier: "searchResultsController") as? SearchResultsTableViewController
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
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
