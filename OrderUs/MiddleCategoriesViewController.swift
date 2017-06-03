//
//  MiddleCategoriesTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 02/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

class MiddleCategoriesTableViewController: UITableViewController, DataManagerDelegate {
    private let appTintColor = UIColor(red: 244/255, green: 124/255, blue: 32/255, alpha: 1)
    
    var dataChangedFunctionCalled: Bool = false
    func dataChanged(newList: [Category]) {
        categories = newList
        dataChangedFunctionCalled = true
        tableView.reloadData()
    }
    
    var tableViewOriginalSize: CGRect?
    
    private var rowHeightRange = Range<CGFloat>(uncheckedBounds: (lower: 100, upper: 200))
    private var rowHeight: CGFloat {
        let bestHeight = tableView.frame.height / 6
        if bestHeight < rowHeightRange.lowerBound {
            return rowHeightRange.lowerBound
        } else if bestHeight > rowHeightRange.upperBound {
            return rowHeightRange.upperBound
        }
        return bestHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableViewOriginalSize = tableView.frame
        initializeSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var categories: [Category] = [] {
        didSet {
            searchResultsController?.tableList = categories
        }
    }
    
    struct Constants {
        static let noSelectedSection = -1
    }
    
    func pushAnInstanceOfThisView(with list: [Category], name: String) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "MiddleCategoriesController") as? MiddleCategoriesTableViewController {
            vc.categories = list
            vc.title = name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    var selectedSection: Int = Constants.noSelectedSection
    
    private func setCollapseData(with section: Int?) {
        if let s = section {
            if selectedSection != s {
                selectedSection = s
            } else {
                selectedSection = Constants.noSelectedSection
            }
            //            let indexPath = IndexPath(row: 0, section: s)
            //            tableView.beginUpdates()
            //            tableView.reloadRows(at: [indexPath], with: .none)
            //            tableView.endUpdates()
            //            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? CategoriesTableViewController, segue.identifier == "Items" {
            if let index = sender as? Int {
                dvc.tableList = categories[index].Children
                dvc.title = categories[index].Name
            } else if let indexInfo = sender as? (selected: Category, parentIndex: Int) {
                dvc.tableList = indexInfo.selected.Children
                dvc.title = indexInfo.selected.Name
            }
        }
    }
    
    func didSelectSection(at section: Int?) {
        if section != nil {
            if categories[section!].ChildrenCategories.isEmpty {
                // go to items view controller
                performSegue(withIdentifier: "Items", sender: section!)
            } else {
                setCollapseData(with: section)
            }
        }
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
        searchResultsController?.tableList = categories
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
    
    // UITableViewDelegate - start
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
        //        return (selectedSection == indexPath.section) ? tableView.rowHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCategoryCell")
        if let categoryCell = cell as? MiddleCategoriesTableViewCell {
            categoryCell.category = categories[section]
            categoryCell.controller = self
            categoryCell.indexSection = section
        }
        return cell
    }
    
    // UITableViewDelegate - end
    
    // UITableViewDataSource - start
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !categories[section].ChildrenCategories.isEmpty {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCategoryCollection", for: indexPath)
            if let categoriesCell = cell as? BottomCategoriesTableViewCell {
                categoriesCell.categories = categories[indexPath.section].Children.categories()
                categoriesCell.containerHeight = rowHeight
                categoriesCell.controller = self
                categoriesCell.parentIndex = indexPath.section
            }
        }
        return cell
    }
    // UITableViewDataSource - end
}
