//
//  BottomCategoriesCollectionViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 02/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class BottomCategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var categoryNameOutlet: UILabel!
    
    var categoryImageURL = ""
    var categoryLabel = ""
    var category: Category? {
        didSet {
            if category != nil {
                categoryImageURL = category!.ImageURL
                categoryLabel = category!.Name
                updateUI()
            }
        }
    }
    
    func updateUI() {
        categoryNameOutlet.text = categoryLabel
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
