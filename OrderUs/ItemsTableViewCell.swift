//
//  CategoriesTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var item: Item! {
        didSet {
            if item != nil {
                updateUI()
            }
        }
    }
    
    private func updateUI() {
        itemLabel.text = item.Name
        updateImage()
    }
    
    private func updateImage() {
        spinner.startAnimating()
        item.applyImage(to: itemImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
