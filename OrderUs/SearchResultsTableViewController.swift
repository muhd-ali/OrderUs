//
//  SearchResultsTableViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-04-28.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    static func initializeFor(tableList: [Selectable], navigationController: UINavigationController?, delegate: UISearchBarDelegate?, searchBarView: UIView?) -> SearchResultsTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchResultsController = storyboard.instantiateViewController(withIdentifier: "searchResultsController") as? SearchResultsTableViewController
        searchResultsController?.tableList = tableList
        searchResultsController?.parentNavigationController = navigationController
        
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchResultsController?.searchController = searchController
        searchController.searchResultsUpdater = searchResultsController
        searchController.dimsBackgroundDuringPresentation = true
        
        let searchBar = searchController.searchBar
        if delegate != nil {
            searchBar.delegate = delegate
        }
        searchBar.barTintColor = MainMenuViewController.Constants.appTintColor
        searchBar.tintColor = UIColor.white
        searchBarView?.addSubview(searchBar)
        searchBar.sizeToFit()
        searchResultsController?.searchBar = searchBar
        return searchResultsController!
    }
    
    var tableList: [Selectable]?
    var searchBar: UISearchBar?
    var parentNavigationController: UINavigationController?
    var searchController: UISearchController?
    internal var results: [SearchResult] = []
    private var rowHeight: CGFloat {
        return tableView.bounds.height / 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset.top = 64
        let nib = UINib(nibName: "SearchHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "SearchHeaderView")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchHeaderView")
        if let searchHeader = view as? SearchHeaderView {
            searchHeader.searchLabel.attributedText = results[section].attributedPath
            let bgColor = UIColor.groupTableViewBackground
            searchHeader.contentView.backgroundColor = bgColor
            searchHeader.backgroundColor = bgColor
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        if let resultCell = cell as? SearchResultsTableViewCell {
            let result = results[indexPath.section]
            resultCell.result = result
            resultCell.rowHeight = rowHeight
            resultCell.controller = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    
    func selected(selectable: Selectable) {
        if let category = selectable as? Category {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ItemsViewController") as? ItemsViewController, category.containsItems {
//                vc.items = category.Children.items()
//                vc.title = category.Name
//                dismiss(animated: true) { [unowned uoSelf = self] in
//                    uoSelf.parentNavigationController?.pushViewController(vc, animated: true)
//                }
            } else if let vc = storyboard?.instantiateViewController(withIdentifier: "TreeHeirarchyViewController") as? SelectableViewController {
                vc.categories = category.Children.categories()
                dismiss(animated: true) { [unowned uoSelf = self] in
                    uoSelf.parentNavigationController?.pushViewController(vc, animated: true)
                }
            }
            
        } else if let item = selectable as? Item {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailsViewController {
                vc.item = item; vc.title = item.Name
                dismiss(animated: true) { [unowned uoSelf = self] in
                    uoSelf.parentNavigationController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}

extension SearchResultsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchedText = searchController.searchBar.text {
            results = tableList?.searchSelectablesFromWholeTree(containing: searchedText) ?? []
            tableView.reloadData()
        }
    }
}
