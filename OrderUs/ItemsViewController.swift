//
//  ItemsViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 26/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var itemsTableViewContainer: UIView!
    @IBOutlet weak var noItemsTableViewContainer: UIView!
    
    internal var categories = [Category]()
    internal var selectedCategory = IndexPath(item: 0, section: 0)
    
    private func setContainerViews() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
