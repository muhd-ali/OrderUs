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
        if categories[indexPath.item].ChildrenCategories.isEmpty {
            
        }
    }
}
