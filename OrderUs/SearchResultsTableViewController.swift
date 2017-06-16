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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        
        let result = results[indexPath.row]
        
        cell.textLabel?.text = result.item.Name
        cell.detailTextLabel?.attributedText = result.attributedPath
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailsViewController {
            let item = results[indexPath.row].item
            vc.item = item; vc.title = item.Name
            dismiss(animated: true) { [unowned uoSelf = self] in
                uoSelf.parentNavigationController?.pushViewController(vc, animated: true)
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
