//
//  CategoriesRootTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 31/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import SDWebImage

class CategoriesRootTableViewCellBody: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var categoryImageURL = ""
    
    var category: Category? {
        didSet {
            if let url = category?.ImageURL {
                categoryImageURL = url
                updateUI()
            }
        }
    }
    
    func updateUI() {
        updateImage()
    }

    private func updateImage() {
        if let url = URL(string: categoryImageURL) {
            spinner.startAnimating()
            categoryImage.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }
    
}
