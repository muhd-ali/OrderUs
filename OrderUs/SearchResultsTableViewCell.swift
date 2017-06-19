//
//  SearchResultsTableViewCell.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-19.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultPathCollectionView: UICollectionView!
    
    var rowHeight: CGFloat!
    var controller: SearchResultsTableViewController!
    var result: SearchResult! {
        didSet {
            if result != nil {
                resultLabel.attributedText = result.attributedPath
                resultPathCollectionView.dataSource = self
                resultPathCollectionView.delegate = self
                resultPathCollectionView.reloadData()
            }
        }
    }
    
    internal func isLinkCell(at indexPath: IndexPath) -> Bool {
        return !(indexPath.item % 2 == 0)
    }
    
   internal func resultIndexFromCell(with indexPath: IndexPath) -> Int {
        return ((indexPath.item + 2) / 2) - 1
    }
}

extension SearchResultsTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectable = result.path[resultIndexFromCell(with: indexPath)]
        controller.selected(selectable: selectable)
    }
}

extension SearchResultsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var side: CGFloat = rowHeight - (resultLabel.bounds.height + 16)
        if isLinkCell(at: indexPath) {
            side = side / 3
        }
        
        return CGSize(width: side, height: side)
    }
}

extension SearchResultsTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 * (result.path.count) - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if isLinkCell(at: indexPath) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "linkCell", for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultPathCollectionViewCell", for: indexPath)
            
            if let nodeCell = cell as? ResultPathCollectionViewCell {
                let resultIndex = resultIndexFromCell(with: indexPath)
                nodeCell.selectable = result.path[resultIndex]
            }
        }
        
        return cell
    }
}
