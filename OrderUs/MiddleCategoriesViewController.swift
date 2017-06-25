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
    private let appTintColor = MainMenuViewController.Constants.appTintColor
    
    var dataChangedFunctionCalled: Bool = false
    func dataChanged(newList: [Category]) {
        categories = newList
        dataChangedFunctionCalled = true
        tableView.reloadData()
    }
    
    private var rowHeightRange = Range<CGFloat>(uncheckedBounds: (lower: 100, upper: 200))
    private var rowHeight: CGFloat {
        let bestHeight = tableView.bounds.height / 6
        if bestHeight < rowHeightRange.lowerBound {
            return rowHeightRange.lowerBound
        } else if bestHeight > rowHeightRange.upperBound {
            return rowHeightRange.upperBound
        }
        return bestHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        DataManager.sharedInstance.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        initializeSearchController()
        let nib = UINib(nibName: "MiddleCategoriesCellView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "MiddleCategoriesCellView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var categories: [Category] = []
    
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
            
            tableView.beginUpdates()
            let indexPath = IndexPath(row: 0, section: s)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            tableView.scrollToRow(at: IndexPath(row: 0, section: s), at: .none, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ItemsTableViewController, segue.identifier == "Items" {
            if let index = sender as? Int {
                dvc.tableList = categories[index].Children.items()
                dvc.title = categories[index].Name
            } else if let indexInfo = sender as? (selected: Category, parentIndex: Int) {
                dvc.tableList = indexInfo.selected.Children.items()
                dvc.title = indexInfo.selected.Name
            }
        }
    }
    
    func didSelectSection(at section: Int?) {
        if section != nil {
            if categories[section!].containsItems {
                performSegue(withIdentifier: "Items", sender: section!)
            } else {
                setCollapseData(with: section)
            }
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        let searchBarHeight: CGFloat = tableView.tableHeaderView!.bounds.height
        let navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarView?.bounds.height ?? 0
        let navigationBarOffset = (navigationBarHeight + statusBarHeight) - searchBarHeight
        if tableView.contentOffset.y == -CGFloat(searchBarHeight + navigationBarOffset) {
            UIView.animate(withDuration: 0.2) { [unowned uoSelf = self] in
                uoSelf.tableView.contentOffset = CGPoint(x: 0, y: -navigationBarOffset)
            }
        } else {
            let indexPath = IndexPath(row: NSNotFound, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func hideSearchBar() {
        if tableView.contentOffset.y == 0.0 {
            let searchBarHeight = tableView.tableHeaderView!.bounds.height
            tableView.contentOffset = CGPoint(x: 0.0, y: searchBarHeight)
        }
    }
    
    private func initializeSearchController() {
        tableView.tableHeaderView = SearchResultsTableViewController.initializeFor(tableList: categories, navigationController: navigationController, delegate: nil, searchBarView: nil)
        hideSearchBar()
    }
    
    // UITableViewDelegate - start
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (selectedSection == indexPath.section) ? rowHeight : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let categoryCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MiddleCategoriesCellView")
        if let cell = categoryCell as? MiddleSuperCategoryView {
            let category = categories[section]
            cell.category = category
            cell.controller = self
            cell.indexSection = section
        }
        return categoryCell
    }
    // UITableViewDelegate - end
    
    
    // UITableViewDataSource - start
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !categories[section].containsItems {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MiddleCategoryCollection", for: indexPath)
            if let categoriesCell = cell as? BottomCategoriesTableViewCell {
                let category = categories[indexPath.section]
                categoriesCell.categories = category.Children.categories()
                categoriesCell.containerHeight = rowHeight
                categoriesCell.controller = self
                categoriesCell.parentIndex = indexPath.section
            }
        }
        return cell
    }
    // UITableViewDataSource - end
}
