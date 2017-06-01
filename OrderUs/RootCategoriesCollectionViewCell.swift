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
    @IBOutlet weak var categoryLabelOutlet: UILabel!
    
    var collectionView: UICollectionView?
    
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
        categoryLabelOutlet.text = categoryLabel
        let frame = categoryLabelOutlet.frame
        categoryLabelOutlet.frame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: frame.width,
            height: 0
        )
        updateImage()
//        addDropShadow()
    }
    
    func addDropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: self.contentView.layer.cornerRadius
            ).cgPath
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
