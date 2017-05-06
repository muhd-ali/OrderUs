//
//  SearchResultsTableViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-04-28.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating {
    struct SearchResult {
        var item: DataManager.Item
        var path: NSMutableAttributedString
    }
    
    var tableList: DataManager.ListType?
    var parentNavigationController: UINavigationController?
    var searchController: UISearchController?
    internal var results: [SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
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
        cell.detailTextLabel?.attributedText = result.path
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailsViewController {
            let item = results[indexPath.row].item
            vc.item = item
            vc.title = item.Name
            parentNavigationController?.pushViewController(vc, animated: true)
            
        }
    }

    // MARK: - UISearchResultsUpdating
    
    internal func findSearchResults(fromList list: DataManager.ListType, listPath: String, withSearchedText text: String) -> [SearchResultsTableViewController.SearchResult] {
        let jaggedResults:[[SearchResultsTableViewController.SearchResult]] = list.map { listItem in
            var foundResults: [SearchResultsTableViewController.SearchResult] = []
            if let category = listItem as? DataManager.Category {
                foundResults = findSearchResults(fromList: category.Children, listPath: "\(listPath) -> \(category.Name)", withSearchedText: text)
            } else if let item = listItem as? DataManager.Item {
                if (!text.isEmpty) {
                    if item.Name.range(of: text) != nil {
                        let fontSize: CGFloat = 15.0
                        let path = "\(listPath) -> \(item.Name)"
                        let attributedPath = NSMutableAttributedString(string: path, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)])
                        let highlightAttribute = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSBackgroundColorAttributeName : UIColor.yellow]
                        attributedPath.addAttributes(highlightAttribute, range: (path as NSString).range(of: text))
                        let foundResult = SearchResultsTableViewController.SearchResult(item: item, path: attributedPath)
                        foundResults.append(foundResult)
                    }
                }
            }
            return foundResults
        }
        return jaggedResults.flatMap { $0 }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchedText = searchController.searchBar.text {
            results = findSearchResults(fromList: tableList ?? [], listPath: "list", withSearchedText: searchedText)
            tableView.reloadData()
        }
    }
    
}
