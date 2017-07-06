//
//  ItemsViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 26/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var itemDetailContainerView: UIView!
    @IBOutlet weak var noItemsDetailView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    
    var items = [Item]()
    var selectedRowIndex = IndexPath(row: 0, section: 0) {
        didSet {
            itemsTableView.reloadRows(at: [oldValue, selectedRowIndex], with: .automatic)
        }
    }
    private var itemDetailViewController: ItemDetailsViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ItemDetailsViewController, items.count > 0 {
            itemDetailViewController = dvc
            dvc.item = items[selectedRowIndex.row]
        }
    }
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        searchBarIsHidden ? showSearchBar() : hideSearchBar()
    }
    
    private var searchBarIsHidden = true
    internal var searchController: SearchResultsTableViewController?
    private func initializeSearchController() {
        searchController = SearchResultsTableViewController.initializeFor(tableList: items, navigationController: navigationController, delegate: self, searchBarView: searchView)
        hideSearchBar()
    }
    
    private func animateLayout(delay: TimeInterval) {
        UIView.animate(withDuration: MainMenuViewController.Constants.animationDuration, delay: delay, options: [.curveEaseInOut], animations: { [unowned uoSelf = self] in
            uoSelf.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func hideSearchBar() {
        hideSearchBar(delay: 0)
    }
    
    internal func hideSearchBar(delay: TimeInterval) {
        view.layoutIfNeeded()
        searchBarIsHidden = true
        searchViewTopConstraint.constant = -searchView.bounds.height
        animateLayout(delay: delay)
    }
    
    private func showSearchBar() {
        view.layoutIfNeeded()
        searchBarIsHidden = false
        searchViewTopConstraint.constant = 0
        animateLayout(delay: 0)
    }
    
    private func setupDetailView() {
        if items.count > 0 {
            noItemsDetailView.removeFromSuperview()
        } else {
            itemDetailContainerView.removeFromSuperview()
        }
    }
    
    private func setupTableView() {
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.layer.zPosition = 2
    }
    
    internal func updateDetailView(to indexPath: IndexPath) {
        itemDetailViewController?.viewWillDisappear(true) // {
        let animationDuration: TimeInterval = MainMenuViewController.Constants.animationDuration
        UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
            let frame = uoSelf.itemDetailContainerView.frame
            uoSelf.itemDetailContainerView.frame = frame.offsetBy(dx: -frame.width, dy: 0)
        }) { [unowned uoSelf = self] (completed1) in
            if completed1 {
                uoSelf.itemDetailViewController?.viewDidDisappear(true)
                // }
                uoSelf.selectedRowIndex = indexPath
                uoSelf.itemDetailViewController?.item = uoSelf.items[uoSelf.selectedRowIndex.row]
                uoSelf.itemDetailViewController?.viewWillAppear(true) // {
                UIView.animate(withDuration: animationDuration, animations: {
                    let frame = uoSelf.itemDetailContainerView.frame
                    uoSelf.itemDetailContainerView.frame = frame.offsetBy(dx: frame.width, dy: 0)
                }) { (completed2) in
                    if completed2 {
                        uoSelf.itemDetailViewController?.viewDidAppear(true)
                        // }
                    }
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSearchController()
        setupDetailView()
        setupTableView()
    }
}

extension ItemsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar(delay: 0.3)
    }
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath != selectedRowIndex else { return }
        selectedRowIndex = indexPath
        updateDetailView(to: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.25 * view.bounds.width
    }
}

extension ItemsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        if let itemCell = cell as? ItemsTableViewCell {
            itemCell.item = items[indexPath.row]
            if indexPath.row == selectedRowIndex.row {
                itemCell.contentView.backgroundColor = UIColor.white
                itemCell.itemLabel.textColor = UIColor.black
            } else {
                itemCell.updateBGColor()
                itemCell.itemLabel.textColor = UIColor.white
            }
        }
        return cell
        
    }
}
