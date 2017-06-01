//
//  RootCategoriesCollectionViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 01/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class RootCategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var categoryImageURL = ""
    var category: Category? {
        didSet {
            if category != nil {
                categoryImageURL = category!.ImageURL
                updateUI()
            }
        }
    }
    
    func updateUI() {
        updateImage()
    }
    
    func updateImage() {
        if let url = URL(string: categoryImageURL) {
            spinner.startAnimating()
            categoryImage.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }
}
