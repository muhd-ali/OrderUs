//
//  Selectable.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-16.
//  Copyright © 2017 PRO. All rights reserved.
//

import Foundation
import SDWebImage

class Selectable { // Never to be Instantiated!!!
    let Name: String
    let ImageURL: String
    let Parent: String
    let ID: String
    
    internal init(rawSelectable: [String: Any]) {
        Name =  rawSelectable["Name"]! as! String
        ImageURL = "\(ServerCommunicator.Constants.serverIP)/\(rawSelectable["imageURL"]! as! String)".replacingOccurrences(of: " ", with: "%20")
        Parent = rawSelectable["Parent"]! as! String
        ID = rawSelectable["_id"]! as! String
    }
    
    internal init(Name: String, ImageURL: String, Parent: String, ID: String) {
        self.Name = Name
        self.ImageURL = ImageURL
        self.Parent = Parent
        self.ID = ID
    }
    
    func applyImage(to imageView: UIImageView, completion: (() -> Void)?) {
        if let url = URL(string: ImageURL) {
            imageView.sd_setImage(with: url) { (uiImage, error, cacheType, url) in
                completion?()
            }
        }
    }
}

struct SearchResult {
    var selectable: Selectable
    var path: [Selectable]
    var searchedText: String?
    
    var attributedPath: NSMutableAttributedString? {
        guard searchedText != nil else { return nil }
        let fontSize: CGFloat = 12.0
        let attributedPath = NSMutableAttributedString(string: path.last!.Name, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: fontSize)])
        let highlightAttributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize), NSBackgroundColorAttributeName : UIColor.yellow]
        attributedPath.addAttributes(highlightAttributes, range: (path.last!.Name.lowercased() as NSString).range(of: searchedText!.lowercased()))
        return attributedPath
    }
}

extension Sequence where Iterator.Element == Selectable {
    private func searchSelectablesFromWholeTreeHelper(condition: (Selectable) -> Bool, path: [Selectable]) -> [SearchResult] {
        var results: [SearchResult] = []
        self.forEach { selectable in
            if let category = selectable as? Category {
                var mutablePath = path
                mutablePath.append(category)
                let innerResults = category.Children.searchSelectablesFromWholeTreeHelper(condition: condition, path: mutablePath)
                results.append(contentsOf: innerResults)
            }
            if condition(selectable) {
                var mutablePath = path
                mutablePath.append(selectable)
                let result = SearchResult(selectable: selectable, path: mutablePath, searchedText: nil)
                results.append(result)
            }
        }
        return results
    }
    
    private func searchSelectablesFromWholeTree(condition: (Selectable) -> Bool) -> [SearchResult]  {
        return searchSelectablesFromWholeTreeHelper(condition: condition, path: [])
    }
    
    func searchSelectablesFromWholeTree(containing string: String) -> [SearchResult] {
        let results = self.searchSelectablesFromWholeTree { result in
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
