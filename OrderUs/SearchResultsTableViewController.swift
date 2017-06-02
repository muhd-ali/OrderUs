//
//  SearchResultsTableViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-04-28.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    var tableList: DataManager.ListType?
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
    private func findSearchResults(fromList list: DataManager.ListType, withSearchedText text: String) -> [SearchResult] {
        let results = list.searchItemsFromWholeTree { result in
            result.Name.lowercased().range(of: text.lowercased()) != nil
        }
        
        return results.map {
            var result = $0
            let fontSize: CGFloat = 12.0
            let attributedPath = result.path.map { pathStep in NSMutableAttributedString(string: pathStep, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)])}
            let highlightAttributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSBackgroundColorAttributeName : UIColor.yellow]
            attributedPath.last?.addAttributes(highlightAttributes, range: (result.path.last!.lowercased() as NSString).range(of: text.lowercased()))
            result.attributedPath = attributedPath.reduce(nil) {
                var str = $0.0
                if str == nil {
                    str = NSMutableAttributedString()
                } else {
                    str?.append(NSMutableAttributedString(string: "->"))
                }
                str?.append($0.1)
                return str
            }
            return result
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchedText = searchController.searchBar.text {
            results = findSearchResults(fromList: tableList ?? [], withSearchedText: searchedText)
            tableView.reloadData()
        }
    }
}
