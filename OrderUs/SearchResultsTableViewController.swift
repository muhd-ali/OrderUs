//
//  SearchResultsTableViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-04-28.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    var tableList: [Selectable]?
    var parentNavigationController: UINavigationController?
    var searchController: UISearchController?
    internal var results: [SearchResult] = []
    private var rowHeight: CGFloat {
        return tableView.bounds.height / 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        if let resultCell = cell as? SearchResultsTableViewCell {
            let result = results[indexPath.row]
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
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ItemsTableViewController") as? ItemsTableViewController, category.containsItems {
                vc.tableList = category.Children.items()
                vc.title = category.Name
                dismiss(animated: true) { [unowned uoSelf = self] in
                    uoSelf.parentNavigationController?.pushViewController(vc, animated: true)
                }
            } else if let vc = storyboard?.instantiateViewController(withIdentifier: "MiddleCategoriesController") as? MiddleCategoriesTableViewController {
                vc.categories = category.Children.categories()
                vc.title = category.Name
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
            results = tableList?.searchItemsFromWholeTree(containing: searchedText) ?? []
            tableView.reloadData()
        }
    }
}
