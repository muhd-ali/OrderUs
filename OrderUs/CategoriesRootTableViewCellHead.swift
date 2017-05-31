//
//  CategoriesRootTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 31/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class CategoriesRootTableViewCellHead: UITableViewCell {
    @IBOutlet weak var categoryNameOutlet: UILabel!
    
    var categoryName = ""
    
    var category: Category? {
        didSet {
            if let name = category?.Name {
                categoryName = name
                updateUI()
            }
        }
    }
    
    private func addDropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    func updateUI() {
        categoryNameOutlet.text = categoryName
        addDropShadow()
    }
    
}
