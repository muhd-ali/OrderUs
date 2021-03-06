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
    private let appTintColor = MainMenuViewController.Constants.appTintColor
    private let animationDuration: TimeInterval = MainMenuViewController.Constants.animationDuration
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var blurViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var seatchBarViewTopOffset: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    @IBOutlet weak var trackingButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var shoppingCartButtonOutlet: UIBarButtonItem!
    
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        searchBarIsHidden ? showSearchBar() : hideSearchBar()
    }
    
    private func initializeBlurMenu() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        blurView.addGestureRecognizer(recognizer)
    }
    
    @objc func blurViewTapped(recognizer: UITapGestureRecognizer) {
        revealViewController().revealToggle(nil)
    }
    
    private func initializeSideMenu() {
        let rvc = self.revealViewController()
        if rvc != nil {
            sideMenuButtonOutlet.target = rvc
            sideMenuButtonOutlet.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        hideBlurView()
        SideMenuTableViewController.delegate = self
    }
    
    internal func showBlurView() {
        blurView.isHidden = false
        blurViewTopConstraint.constant = 0
        blurViewBottomConstraint.constant = -(tabBarController?.tabBar.bounds.height ?? 0)
        UIView.animate(withDuration: animationDuration) { [unowned uoSelf = self] in
            uoSelf.blurView.layer.opacity = 1
        }
    }
    
    internal func hideBlurView() {
        UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
            uoSelf.blurView.layer.opacity = 0
        }) { [unowned uoSelf = self] (completed) in
            if completed {
                let height = uoSelf.view.bounds.height
                uoSelf.blurViewTopConstraint.constant = -height
                uoSelf.blurViewBottomConstraint.constant = height
                uoSelf.blurView.isHidden = true
            }
        }
    }
    
    private func setNavigationBarColors() {
        navigationController?.navigationBar.barTintColor = appTintColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.sharedInstance.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? RootCategoriesCollectionViewLayout {
            layout.delegate = self
        }
        setNavigationBarColors()
        initializeSideMenu()
        initializeBlurMenu()
    }
    
    internal func hideTabBar() {
        if let tc = tabBarController as? MainMenuViewController {
            tc.hideTabBar(animated: true)
        }
    }
    
    internal func showTabBar() {
        if let tc = tabBarController as? MainMenuViewController {
            tc.showTabBar(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeSearchController() // breaks if called in viewDidLoad()
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
        hideSearchBar()
        if let dvc = segue.destination as? SelectableViewController      ,
            let index = sender as? Int,
            segue.identifier == "MiddleCategories" {
            dvc.categories = categories
            dvc.selectedMasterIndex = IndexPath(row: index, section: 0)
        }
    }
    
    private func animateLayout(delay: TimeInterval) {
        UIView.animate(withDuration: animationDuration, delay: delay, options: [.curveEaseInOut], animations: { [unowned uoSelf = self] in
            uoSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func hideSearchBar() {
        hideSearchBar(delay: 0)
    }
    
    internal func hideSearchBar(delay: TimeInterval) {
        view.layoutIfNeeded()
        searchBarIsHidden = true
        seatchBarViewTopOffset.constant = -searchBarView.bounds.height
        animateLayout(delay: delay)
    }
    
    private func showSearchBar() {
        view.layoutIfNeeded()
        searchBarIsHidden = false
        seatchBarViewTopOffset.constant = 0
        animateLayout(delay: 0)
    }
    
    private var searchBarIsHidden = true
    private func initializeSearchController() {
        _ = SearchResultsTableViewController.initializeFor(tableList: categories, navigationController: navigationController, delegate: self, searchBarView: searchBarView)
        hideSearchBar()
    }
    
    var featureCellIndex: CGFloat = 0
    var lastFeaturedIndex: CGFloat = 0
}

extension RootCategoriesViewController: SideMenuTableViewControllerDelegate {
    func sideMenuDidAppear() {
        showBlurView()
        hideTabBar()
    }
    
    func sideMenuWillDisappear() {
        hideBlurView()
        showTabBar()
    }
}

extension RootCategoriesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar(delay: 0.3)
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
            //            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let cellMaxHeight: CGFloat = 150 // should be collectionView.bounds.height / 2
    //        let collectionViewYOffset = scrollView.contentOffset.y
    //        var featuredCellIndex = CGFloat(Int(collectionViewYOffset / cellMaxHeight))
    //        let cellOffset = collectionViewYOffset.truncatingRemainder(dividingBy: cellMaxHeight)
    //        if (cellOffset > cellMaxHeight / 2) {
    //            featuredCellIndex += 1
    //        }
    //        let targetOffset: CGFloat = featuredCellIndex * cellMaxHeight
    //        print("collectionView.bounds.width = \(collectionView.bounds.width)")
    //    }
    //
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //        let cellMaxHeight: CGFloat = 150 // should be collectionView.bounds.height / 2
    //        let collectionViewYOffset = scrollView.contentOffset.y
    //        var featuredCellIndex = CGFloat(Int(collectionViewYOffset / cellMaxHeight))
    //        guard (abs(featuredCellIndex - lastFeaturedIndex) < 2) else { return }
    //        lastFeaturedIndex = featuredCellIndex
    //        let cellOffset = collectionViewYOffset.truncatingRemainder(dividingBy: cellMaxHeight)
    //        if (cellOffset > cellMaxHeight / 2) {
    //            featuredCellIndex += 1
    //        }
    //        let targetOffset: CGFloat = featuredCellIndex * cellMaxHeight
    //        targetContentOffset.pointee.y = targetOffset
    //    }
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
