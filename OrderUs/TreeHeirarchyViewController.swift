//
//  TreeHeirarchyViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 25/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class TreeHeirarchyViewController: UIViewController {
//    @IBOutlet weak var treeView: TreeHeirarchyView!
//    
//    
//    var dataChangedFunctionCalled: Bool = false
//    func dataChanged(newList: [Category]) {
//        dataChangedFunctionCalled = true
//        masterCategories = newList
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if let dvc = segue.destination as? ItemsViewController, segue.identifier == "Items" {
////            if let category = sender as? Category {
////                dvc.items = category.Children.items()
////                dvc.title = category.Name
////            }
////        }
//    }
//    
//    var masterCategories = DataManager.sharedInstance.categoryTree {
//        didSet {
//            if isViewLoaded {
//                treeView.masterCategoriesChanged(to: masterCategories)
//                searchController?.tableList = masterCategories
//            }
//        }
//    }
//    
//
//    
//    internal func didSelectDetailCategoryAt(indexPath: IndexPath, outOf categories: [Category]) {
//        if !searchBarIsHidden {
//            hideSearchBar()
//        }
//        let selected = categories[indexPath.row]
//        if selected.containsItems {
//            performSegue(withIdentifier: "Items", sender: selected)
//        } else {
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "TreeHeirarchyViewController") as? TreeHeirarchyViewController {
//                vc.masterCategories = categories
//                vc.selectedMasterIndex = indexPath
//                navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//    }
//    internal var masterTableView: UITableView {
//        return treeView.masterTableView
//    }
//    internal var detailTableView: UITableView {
//        return treeView.detailTableView
//    }
//    internal var detailCategories: [Category] {
//        return treeView.detailCategories
//    }
//    
//    var selectedMasterIndex = IndexPath(item: 0, section: 0)
//    
//    private func initializeUI() {
//        automaticallyAdjustsScrollViewInsets = false
//        treeView.initializeUI(
//            with: masterCategories,
//            selectedRowIndex: selectedMasterIndex,
//            controller: self
//        )
//    }
//}
//
//extension TreeHeirarchyViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch tableView.tag {
//        case masterTableView.tag:
//            treeView.didSelectMasterRowAt(indexPath: indexPath)
//            searchController?.tableList = treeView.detailCategories
//        case detailTableView.tag:
//            didSelectDetailCategoryAt(indexPath: indexPath, outOf: detailCategories)
//        default:
//            break
//        }
//    }
//}
//
//extension TreeHeirarchyViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        switch tableView.tag {
//        case masterTableView.tag:
//            return 1
//        case detailTableView.tag:
//            return 1
//        default:
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableView.tag {
//        case masterTableView.tag:
//            return masterCategories.count
//        case detailTableView.tag:
//            return detailCategories.count
//        default:
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch tableView.tag {
//        case masterTableView.tag:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TreeHeirarchyViewMasterCell", for: indexPath)
//            if let detailCell = cell as? TreeHeirarchyViewMasterTableViewCell {
//                detailCell.category = masterCategories[indexPath.row]
//            }
//            cell.selectionStyle = .none
//            var bgColor = UIColor()
//            if indexPath == treeView.selectedMasterIndex {
//                bgColor = TreeHeirarchyView.ColorScheme.masterSelectedBG
//            } else {
//                bgColor = TreeHeirarchyView.ColorScheme.masterUnselectedBG
//            }
//            cell.backgroundColor = bgColor
//            return cell
//        case detailTableView.tag:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TreeHeirarchyViewCategoryDetailCell", for: indexPath)
//            if let detailCell = cell as? TreeHeirarchyViewCategoryDetailTableViewCell {
//                detailCell.category = detailCategories[indexPath.row]
//            }
//            cell.selectionStyle = .none
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        default:
//            return UITableViewCell()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return treeView.masterTableWidth
//    }
}
