//
//  SelectableViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-07-06.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SelectableViewController: UIViewController, DataManagerDelegate {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nothingViewContainer: UIView!
    @IBOutlet weak var masterTableView: UITableView!
    @IBOutlet weak var detailTableView: UITableView!
    
    internal let animationDuration = MainMenuViewController.Constants.animationDuration
    
    struct Constant {
        struct ColorScheme {
            static let masterUnselectedBG = UIColor.black
            static let masterSelectedBG = UIColor.white
        }
        
        struct CellName {
            static let masterCell = "SelectableMasterViewCell"
            static let detailCategoryCell = "SelectableDetailViewCategoryCell"
            static let detailItemCell = "SelectableDetailViewItemCell"
        }
    }
    
    internal var masterTableWidth: CGFloat {
        return 0.25 * view.bounds.width
    }
    
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        searchBarIsHidden ? showSearchBar() : hideSearchBar()
    }
    
    var dataChangedFunctionCalled: Bool = false
    func dataChanged(newList: [Category]) {
        dataChangedFunctionCalled = true
        categories = newList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        DataManager.sharedInstance.delegate = self
        hideSearchBar()
        initializeTableViews()
        initializeSearchController()
    }
    
    private func initializeTableViews() {
        let masterZPosition: CGFloat = 10
        masterTableView.layer.zPosition = masterZPosition
        masterTableView.tag = Int(masterZPosition)
        masterTableView.dataSource = self
        masterTableView.delegate = self
        masterTableView.backgroundColor = Constant.ColorScheme.masterUnselectedBG
        let nib1 = UINib(nibName: Constant.CellName.masterCell, bundle: nil)
        masterTableView.register(nib1, forCellReuseIdentifier: Constant.CellName.masterCell)
        
        detailTableView.layer.zPosition = masterZPosition - 1
        detailTableView.tag = masterTableView.tag - 1
        detailTableView.dataSource = self
        detailTableView.delegate = self
        let nib2 = UINib(nibName: Constant.CellName.detailCategoryCell, bundle: nil)
        detailTableView.register(nib2, forCellReuseIdentifier: Constant.CellName.detailCategoryCell)
        let nib3 = UINib(nibName: Constant.CellName.detailItemCell, bundle: nil)
        detailTableView.register(nib3, forCellReuseIdentifier: Constant.CellName.detailItemCell)
    }
    
    var selectedMasterIndex = IndexPath(row: 0, section: 0) {
        didSet {
            masterTableView?.reloadRows(at: [oldValue, selectedMasterIndex], with: .automatic)
        }
    }
    
    internal var selectedCategory: Category {
        return categories[selectedMasterIndex.row]
    }
    
    var categories = DataManager.sharedInstance.categoryTree
    internal var children: [Selectable] {
        return selectedCategory.Children
    }
    
    internal var searchBarIsHidden = true
    internal var searchController: SearchResultsTableViewController?
    private func initializeSearchController() {
        let index = selectedMasterIndex.row
        guard categories.count > index else { return }
        let selected = categories[index]
        searchController = SearchResultsTableViewController.initializeFor(
            tableList: selected.Children.categories(),
            navigationController: navigationController,
            delegate: self,
            searchBarView: searchView
        )
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideSearchBar()
        if segue.identifier == "Item" {
            if let dvc = segue.destination as? ItemDetailsViewController,
               let indexPath = sender as? IndexPath {
                let items = selectedCategory.Children.items()
                dvc.item = items[indexPath.row]
            }
        }
    }
}

extension SelectableViewController {
    internal func masterCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellName.masterCell, for: indexPath)
        if let categoryCell = cell as? SelectableMasterViewCell {
            categoryCell.category = categories[indexPath.row]
        }
        cell.selectionStyle = .none
        var bgColor = UIColor()
        if indexPath == selectedMasterIndex {
            bgColor = Constant.ColorScheme.masterSelectedBG
        } else {
            bgColor = UIColor.clear
        }
        cell.backgroundColor = bgColor
        return cell
    }
    
    internal func detailCategoryCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellName.detailCategoryCell, for: indexPath)
        if let categoryCell = cell as? SelectableDetailViewCategoryCell {
            categoryCell.category = selectedCategory.Children[indexPath.row] as! Category
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    internal func detailItemCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellName.detailItemCell, for: indexPath)
        if let itemCell = cell as? SelectableDetailViewItemCell {
            itemCell.item = selectedCategory.Children[indexPath.row] as! Item
        }
        return cell
    }
    
    internal func detailCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if selectedCategory.containsItems {
            cell = detailItemCell(for: tableView, at: indexPath)
        } else {
            cell = detailCategoryCell(for: tableView, at: indexPath)
        }
        let bgColor = UIColor.groupTableViewBackground
//        cell.contentView.backgroundColor = bgColor
        cell.backgroundColor = bgColor
        cell.selectionStyle = .none
        return cell
    }
    
    internal func didSelectMasterRow(for tableView: UITableView, at indexPath: IndexPath) {
        if indexPath != selectedMasterIndex {
            selectedMasterIndex = indexPath
            UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
                uoSelf.detailTableView.frame.origin.x -= uoSelf.detailTableView.frame.width
                uoSelf.view.layoutIfNeeded()
            }) { [unowned uoSelf = self] (completed) in
                if completed {
                    uoSelf.detailTableView.reloadData()
                    UIView.animate(withDuration: uoSelf.animationDuration) {
                        uoSelf.detailTableView.frame.origin.x += uoSelf.detailTableView.frame.width
                        uoSelf.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    internal func didSelectDetailRow(for tableView: UITableView, at indexPath: IndexPath) {
        if !searchBarIsHidden {
            hideSearchBar(delay: animationDuration)
        }
        let selected = selectedCategory
        if selected.containsItems {
            performSegue(withIdentifier: "Item", sender: indexPath)
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "SelectableViewController") as? SelectableViewController {
                vc.categories = selectedCategory.Children.categories()
                vc.selectedMasterIndex = indexPath
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension SelectableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar(delay: animationDuration)
    }
}

extension SelectableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView.tag {
        case masterTableView.tag:
            return masterTableWidth
        case detailTableView.tag:
            return masterTableWidth
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case masterTableView.tag:
            didSelectMasterRow(for: tableView, at: indexPath)
        case detailTableView.tag:
            didSelectDetailRow(for: tableView, at: indexPath)
        default:
            break
        }
    }
}

extension SelectableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView.tag {
        case masterTableView.tag:
            return 1
        case detailTableView.tag:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case masterTableView.tag:
            return categories.count
        case detailTableView.tag:
            return children.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case masterTableView.tag:
            return masterCell(for: tableView, at: indexPath)
        case detailTableView.tag:
            return detailCell(for: tableView, at: indexPath)
        default:
            break
        }
        return UITableViewCell()
    }
}
