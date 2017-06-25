//
//  TreeHeirarchyViewDetailTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 25/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class TreeHeirarchyViewDetailTableViewCell: UITableViewCell {
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
        if let url = URL(string: category.ImageURL) {
            spinner.startAnimating()
            nodeImageView.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }
}
