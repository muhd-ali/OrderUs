//
//  CategoriesRootTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 31/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class CategoriesRootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var dataChangedFunctionCalled: Bool = false
    
    func dataChanged(newList: [Category]) {
        categories = newList
        tableView.reloadData()
    }
    
    var categories: [Category] = []
    
    func addSwipeGestureRecognizerToTableView() {
        let downRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.userSwipedDown(recognizer:)))
        downRecognizer.direction = .down
        tableView.addGestureRecognizer(downRecognizer)
        
        let upRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.userSwipedUp(recognizer:)))
        upRecognizer.direction = .up
        tableView.addGestureRecognizer(upRecognizer)
    }
    
    func userSwipedDown(recognizer: UISwipeGestureRecognizer) {
        categories.insert(categories.removeLast(), at: 0)
        
        UIView.transition(
            with: tableView,
            duration: 0.5,
            options: [.curveEaseInOut, .transitionCurlDown],
            animations: { [unowned uoSelf = self] in
                uoSelf.tableView.reloadData()
            },
            completion: nil)
    }
    
    func userSwipedUp(recognizer: UISwipeGestureRecognizer) {
        categories.append(categories.removeFirst())
        
        UIView.transition(
            with: tableView,
            duration: 0.5,
            options: [.curveEaseInOut, .transitionCurlUp],
            animations: { [unowned uoSelf = self] in
                uoSelf.tableView.reloadData()
            },
            completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        DataManager.sharedInstance.delegate = self
        addSwipeGestureRecognizerToTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryBody", for: indexPath)
        
        if let categoryCell = cell as? CategoriesRootTableViewCellBody {
            categoryCell.category = categories[indexPath.section % categories.count]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.bounds.height / 15
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryHead") as? CategoriesRootTableViewCellHead {
            cell.category = categories[section % categories.count]
            return cell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.bounds.width
        }
        return 0
    }
}
