//
//  TreeHeirarchyViewDetailTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 25/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class SelectableDetailViewCategoryCell: UITableViewCell {
    @IBOutlet weak var nodeLabel: UILabel!
    @IBOutlet weak var nodeImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var category: Category! {
        didSet {
            if category != nil {
                updateUI()
            }
        }
    }
    
    private func updateUI() {
        nodeLabel.text = category.Name
        updateImage()
    }
    
    private func updateImage() {
        spinner.startAnimating()
        category.applyImage(to: nodeImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
