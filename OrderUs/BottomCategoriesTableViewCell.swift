//
//  BottomCategoriesTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 02/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class BottomCategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    internal var cellDimension: CGFloat = 0
    var containerHeight: CGFloat? {
        didSet {
            if containerHeight != nil {
                cellDimension = containerHeight! * 0.9
            }
        }
    }
    var controller: MiddleCategoriesTableViewController?
    var parentIndex: Int?
    var categories = [Category]() {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.reloadData()
        }
    }
}

extension BottomCategoriesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCategoryCell", for: indexPath)
        if let categoryCell = cell as? BottomCategoriesCollectionViewCell {
            categoryCell.category = categories[indexPath.item]
        }
        return cell
    }
}

extension BottomCategoriesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = categories[indexPath.item]
        if selected.ChildrenCategories.isEmpty {
            // go to items view controller
            controller?.performSegue(withIdentifier: "Items", sender: (selected: selected, parentIndex: parentIndex!))
        } else {
            controller?.pushAnInstanceOfThisView(with: selected.Children.categories(), name: selected.Name)
        }
    }
}

extension BottomCategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellDimension, height: cellDimension)
    }
}
