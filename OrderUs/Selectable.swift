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
    var selectable: Selectable
    var path: [Selectable]
    var searchedText: String?
    
    var attributedPath: NSMutableAttributedString? {
        guard searchedText != nil else { return nil }
        let fontSize: CGFloat = 12.0
        let attributedPath = path.map { pathStep in NSMutableAttributedString(string: pathStep.Name, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)])}
        let highlightAttributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSBackgroundColorAttributeName : UIColor.yellow]
        attributedPath.last?.addAttributes(highlightAttributes, range: (path.last!.Name.lowercased() as NSString).range(of: searchedText!.lowercased()))
        return attributedPath.reduce(NSMutableAttributedString(string: "")) {
            let str = $0.0
            if !str.string.isEmpty {
                str.append(NSMutableAttributedString(string: ">"))
            }
            str.append($0.1)
            return str
        }
    }
}

extension Sequence where Iterator.Element == Selectable {
    private func searchItemsFromWholeTreeHelper(condition: (Item) -> Bool, path: [Selectable]) -> [SearchResult] {
        var results: [SearchResult] = []
        self.forEach { selectable in
            if let category = selectable as? Category {
                var mutablePath = path
                mutablePath.append(category)
                let innerResults = category.Children.searchItemsFromWholeTreeHelper(condition: condition, path: mutablePath)
                results.append(contentsOf: innerResults)
            } else if let item = selectable as? Item {
                if condition(item) {
                    var mutablePath = path
                    mutablePath.append(item)
                    let result = SearchResult(selectable: item, path: mutablePath, searchedText: nil)
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
            var mutable = $0
            mutable.searchedText = string
            return mutable
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
