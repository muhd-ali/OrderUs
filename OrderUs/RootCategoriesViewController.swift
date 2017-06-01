//
//  RootCategoriesViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 31/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import SDWebImage

class RootCategoriesViewController: UIViewController, DataManagerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? RootCategoriesCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    
    var dataChangedFunctionCalled: Bool = false
    func dataChanged(newList: [Category]) {
        dataChangedFunctionCalled = true
        categories = newList
        collectionView.reloadData()
    }
    
    var categories: [Category] = []
    var featuredCellIndexPath = IndexPath(item: 0, section: 0)
}

extension RootCategoriesViewController: RootCategoriesCollectionViewLayoutDelegate {
    func featuredCellChanged(to indexPath: IndexPath) {
        featuredCellIndexPath = indexPath
    }
}

extension RootCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == featuredCellIndexPath {
            let selected = categories[indexPath.row]
            let newTableList = selected.Children
            let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesController") as! CategoriesTableViewController
            vc.tableList = newTableList
            vc.title = selected.Name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
}

extension RootCategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryBody", for: indexPath)
        if let categoryCell = cell as? RootCategoriesCollectionViewCell {
            categoryCell.category = categories[indexPath.item]
            categoryCell.collectionView = collectionView
        }
        return cell
    }
}
