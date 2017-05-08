//
//  SearchResultsTableViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-04-28.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating {
    var tableList: DataManager.ListType?
    var parentNavigationController: UINavigationController?
    var searchController: UISearchController?
    private var results: [SearchResult] = []
    
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
        cell.detailTextLabel?.attributedText = result.attributedPath
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailsViewController {
            let item = results[indexPath.row].item
            vc.item = item; vc.title = item.Name
            parentNavigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    private func findSearchResults(fromList list: DataManager.ListType, listPath: String, withSearchedText text: String) -> [SearchResult] {
        let results = list.searchItems { result in
            result.Name.range(of: text) != nil
        }
        return results.map {
            var result = $0
            let fontSize: CGFloat = 15.0
            result.attributedPath = NSMutableAttributedString(string: result.path, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)])
            let highlightAttributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSBackgroundColorAttributeName : UIColor.yellow]
            result.attributedPath?.addAttributes(highlightAttributes, range: (result.path as NSString).range(of: text))
            return result
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchedText = searchController.searchBar.text {
            results = findSearchResults(fromList: tableList ?? [], listPath: "list", withSearchedText: searchedText)
            tableView.reloadData()
        }
    }
    
}
