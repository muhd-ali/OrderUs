//
//  TreeHeirarchyView.swift
//  OrderUs
//
//  Created by Muhammadali on 25/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol TreeHeirarchyViewDelegate {
    func didSelectDetailCategoryAt(indexPath: IndexPath, outOf categories: [Category])
}

class TreeHeirarchyView: UIView {
//    struct ColorScheme {
//        static let masterUnselectedBG = UIColor.black
//        static let masterSelectedBG = UIColor.white
//    }
//    internal let animationDuration = MainMenuViewController.Constants.animationDuration
//    var selectedMasterIndex = IndexPath(row: 0, section: 0) {
//        didSet {
//            reloadMasterRows(with: [oldValue, selectedMasterIndex])
//            updateDetailCategories()
//        }
//    }
//    
//    private(set) internal var masterTableView: UITableView!
//    internal var masterTableWidth: CGFloat {
//        return 0.25 * bounds.width
//    }
//    private(set) internal var detailTableView: UITableView!
//    
//    private(set) internal var masterCategories = [Category]() {
//        didSet {
//            updateDetailCategories()
//            reloadTables()
//        }
//    }
//    
//    internal func masterCategoriesChanged(to masterCategories: [Category]) {
//        self.masterCategories = masterCategories
//    }
//    
//    private(set) internal var detailCategories = [Category]()
//    private func updateDetailCategories() {
//        if masterCategories.count > selectedMasterIndex.row {
//            let category = masterCategories[selectedMasterIndex.row]
//            detailCategories = category.Children.categories()
//        }
//    }
//    
//    private func reloadMasterRows(with indexPaths: [IndexPath]) {
//        masterTableView.reloadRows(
//            at: indexPaths,
//            with: .automatic
//        )
//    }
//    
//    internal func reloadTables() {
//        masterTableView?.reloadData()
//        detailTableView?.reloadData()
//    }
//    
//    var controller: TreeHeirarchyViewController!
//    private func inititializeTableView(zPosition: Int) -> UITableView {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        //        tableView.contentInset.top = 64
//        tableView.dataSource = controller
//        tableView.delegate = controller
//        tableView.tag = zPosition
//        tableView.layer.zPosition = CGFloat(tableView.tag)
//        tableView.showsVerticalScrollIndicator = false
//        let nib1 = UINib(nibName: "TreeHeirarchyViewMasterCell", bundle: nil)
//        tableView.register(nib1, forCellReuseIdentifier: "TreeHeirarchyViewMasterCell")
//        let nib2 = UINib(nibName: "TreeHeirarchyViewCategoryDetailCell", bundle: nil)
//        tableView.register(nib2, forCellReuseIdentifier: "TreeHeirarchyViewCategoryDetailCell")
//        addSubview(tableView)
//        return tableView
//    }
//    
//    func initializeUI(with masterCategories: [Category], selectedRowIndex: IndexPath!, controller: TreeHeirarchyViewController) {
//        self.controller = controller
//        self.masterCategories = masterCategories
//        masterTableView = inititializeTableView(zPosition: Int(INT_MAX))
//        NSLayoutConstraint.activate([
//            masterTableView.topAnchor.constraint(equalTo: topAnchor),
//            masterTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            masterTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            masterTableView.widthAnchor.constraint(equalToConstant: masterTableWidth),
//            ])
//        masterTableView.backgroundColor = ColorScheme.masterUnselectedBG
//        masterTableView.separatorStyle = .none
//        
//        detailTableView = inititializeTableView(zPosition: masterTableView.tag - 1)
//        NSLayoutConstraint.activate([
//            detailTableView.topAnchor.constraint(equalTo: masterTableView.topAnchor),
//            detailTableView.bottomAnchor.constraint(equalTo: masterTableView.bottomAnchor),
//            detailTableView.leadingAnchor.constraint(equalTo: masterTableView.trailingAnchor),
//            detailTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            ])
//        
//        if selectedRowIndex != nil {
//            selectedMasterIndex = selectedRowIndex
//        }
//    }
//    
//    func didSelectMasterRowAt(indexPath: IndexPath) {
//        if indexPath != selectedMasterIndex {
//            selectedMasterIndex = indexPath
//            UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
//                uoSelf.detailTableView.frame.origin.x -= uoSelf.detailTableView.frame.width
//                uoSelf.layoutIfNeeded()
//            }) { [unowned uoSelf = self] (completed) in
//                if completed {
//                    uoSelf.detailTableView.reloadData()
//                    UIView.animate(withDuration: uoSelf.animationDuration) {
//                        uoSelf.detailTableView.frame.origin.x += uoSelf.detailTableView.frame.width
//                        uoSelf.layoutIfNeeded()
//                    }
//                }
//            }
//        }
//    }
}
