//
//  Selectable.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation

protocol Selectable {
    var Name: String {get}
    var ImageURL: String {get}
    var Parent: String {get}
    var ID: String {get}
}

struct SearchResult {
    var item: Item
    var path: [String]
    var attributedPath: NSMutableAttributedString?
}

extension Sequence where Iterator.Element == Selectable {
    private func searchItemsFromWholeTreeHelper(condition: (Item) -> Bool, path: [String]) -> [SearchResult] {
        var results: [SearchResult] = []
        self.forEach { selectable in
            if let category = selectable as? Category {
                var mutablePath = path
                mutablePath.append(category.Name)
                let innerResults = category.Children.searchItemsFromWholeTreeHelper(condition: condition, path: mutablePath)
                results.append(contentsOf: innerResults)
            } else if let item = selectable as? Item {
                if condition(item) {
                    var mutablePath = path
                    mutablePath.append(item.Name)
                    let result = SearchResult(item: item, path: mutablePath, attributedPath: nil)
                    results.append(result)
                }
            }
        }
        return results
    }
    
    private func searchItemsFromWholeTree(condition: (Item) -> Bool) -> [SearchResult]  {
        return searchItemsFromWholeTreeHelper(condition: condition, path: [])
    }
    
    func searchItemsFromWholeTree(containing string: String) -> [SearchResult] {
        let results = self.searchItemsFromWholeTree { result in
            result.Name.lowercased().range(of: string.lowercased()) != nil
        }
        
        return results.map {
            var result = $0
            let fontSize: CGFloat = 12.0
            let attributedPath = result.path.map { pathStep in NSMutableAttributedString(string: pathStep, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)])}
            let highlightAttributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSBackgroundColorAttributeName : UIColor.yellow]
            attributedPath.last?.addAttributes(highlightAttributes, range: (result.path.last!.lowercased() as NSString).range(of: string.lowercased()))
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
    
    func categories() -> [Category] {
        var cs = [Category]()
        for selectable in self {
            if let category = selectable as? Category {
                cs.append(category)
            }
        }
        return cs
    }

    func items() -> [Item] {
        var its = [Item]()
        for selectable in self {
            if let it = selectable as? Item {
                its.append(it)
            }
        }
        return its
    }
}
