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
    struct Constants {
        static let appTintColor = UIColor(red: 244/255, green: 124/255, blue: 32/255, alpha: 1)
    }
    
    let appTintColor = Constants.appTintColor
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var seatchBarViewTopOffset: NSLayoutConstraint!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBOutlet weak var searchButtonOutlet: UIBarButtonItem!
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        searchBarIsHidden ? showSearchBar() : hideSearchBar()
    }

    @IBOutlet weak var shoppingCartButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var trackingButtonOutlet: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? RootCategoriesCollectionViewLayout {
            layout.delegate = self
        }
        initializeSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    var dataChangedFunctionCalled: Bool = false
    func dataChanged(newList: [Category]) {
        dataChangedFunctionCalled = true
        categories = newList
        if collectionView != nil {
            collectionView.reloadData()
        }
    }
    
    var categories: [Category] = []
    var featuredCellIndexPath = IndexPath(item: 0, section: 0)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? MiddleCategoriesTableViewController,
           let index = sender as? Int,
           segue.identifier == "MiddleCategories" {
            let selected = categories[index]
            dvc.categories = selected.Children.categories()
            dvc.title = selected.Name
        }
    }
    
    private func animateLayout() {
        UIView.animate(withDuration: 0.2) { [unowned uoSelf = self] in
            uoSelf.view.layoutIfNeeded()
        }
    }
    
    internal func hideSearchBar() {
        searchBarIsHidden = true
        seatchBarViewTopOffset.constant = -searchBarView.bounds.height
        animateLayout()
    }
    
    private func showSearchBar() {
        searchBarIsHidden = false
        seatchBarViewTopOffset.constant = 0
        animateLayout()
    }
    
    private var searchBarIsHidden = true
    private var searchController: UISearchController!
    private var searchResultsController: SearchResultsTableViewController?
    
    private func initializeSearchController() {
        searchResultsController = storyboard?.instantiateViewController(withIdentifier: "searchResultsController") as? SearchResultsTableViewController
        searchResultsController?.tableList = categories
        searchResultsController?.parentNavigationController = navigationController
        searchResultsController?.searchController = searchController
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        
        searchController.dimsBackgroundDuringPresentation = true
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.barTintColor = appTintColor
        searchBarView.addSubview(searchBar)
        searchBar.sizeToFit()
        hideSearchBar()
    }
}

extension RootCategoriesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}

extension RootCategoriesViewController: RootCategoriesCollectionViewLayoutDelegate {
    func featuredCellChanged(to indexPath: IndexPath) {
        featuredCellIndexPath = indexPath
    }
}

extension RootCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == featuredCellIndexPath {
            performSegue(withIdentifier: "MiddleCategories", sender: indexPath.item)
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
        }
        return cell
    }
}
