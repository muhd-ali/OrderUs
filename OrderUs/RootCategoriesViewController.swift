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
        static let appTintColor = UIColor(red: 244/255, green: 124/255, blue: 32/255, alpha: 0.1)
    }
    
    let appTintColor = Constants.appTintColor
    let animationDuration: TimeInterval = 0.2
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var blurViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var seatchBarViewTopOffset: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var searchButtonOutlet: UIBarButtonItem!
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        searchBarIsHidden ? showSearchBar() : hideSearchBar()
    }
    
    @IBOutlet weak var shoppingCartButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var trackingButtonOutlet: UIBarButtonItem!
    
    private func initializeBlurMenu() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped))
        blurView.addGestureRecognizer(recognizer)
    }
    
    func blurViewTapped(recognizer: UITapGestureRecognizer) {
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
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
        let frame = tabBarController?.tabBar.frame
        UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
            uoSelf.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: frame?.height ?? 0)
        }) {   [unowned uoSelf = self] (completed) in
            if completed {
                uoSelf.tabBarController?.tabBar.isHidden = true
            }
        }
    }
    
    internal func showTabBar() {
        tabBarController?.tabBar.isHidden = false
        let frame = tabBarController?.tabBar.frame
        UIView.animate(withDuration: animationDuration) { [unowned uoSelf = self] in
            uoSelf.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: -(frame?.height ?? 0))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeSearchController() // breaks if called in viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (tabBarController?.tabBar.isHidden ?? false) {
            showTabBar()
        }
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
        hideTabBar()
        hideSearchBar()
        if let dvc = segue.destination as? MiddleCategoriesTableViewController,
            let index = sender as? Int,
            segue.identifier == "MiddleCategories" {
            let selected = categories[index]
            dvc.categories = selected.Children.categories()
            dvc.title = selected.Name
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
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let featuredCellIndex = CGFloat(RootCategoriesCollectionViewLayout.calculateFeaturedCellIndex(of: collectionView))
        let cellHeight = collectionView.bounds.width / 2
        let cellOffset = scrollView.contentOffset.y.truncatingRemainder(dividingBy: cellHeight)
        var targetOffset: CGFloat = 0
        if (cellOffset > cellHeight / 2) {
            targetOffset += (featuredCellIndex + 1) * cellHeight
        } else {
            targetOffset += featuredCellIndex * cellHeight
        }
        print("offset = \(cellOffset); targetOffset = \(targetOffset)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let featuredCellIndex = CGFloat(RootCategoriesCollectionViewLayout.calculateFeaturedCellIndex(of: collectionView))
        guard ((featuredCellIndex == lastFeaturedIndex + 1) || (featuredCellIndex == lastFeaturedIndex - 1)) else {
            return
        }
        lastFeaturedIndex = featuredCellIndex
        let cellHeight = collectionView.bounds.width / 2
        let cellOffset = scrollView.contentOffset.y.truncatingRemainder(dividingBy: cellHeight)
        var targetOffset: CGFloat = 0
        if (cellOffset > cellHeight / 2) {
            targetOffset += (featuredCellIndex + 1) * cellHeight
        } else {
            targetOffset += featuredCellIndex * cellHeight
        }
        targetContentOffset.pointee.y = targetOffset
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
