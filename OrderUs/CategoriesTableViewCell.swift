//
//  CategoriesTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import SDWebImage

class CategoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var category: Selectable? {
        didSet {
            if category != nil {
                categoryName = category!.Name
                categoryImageURL = category!.ImageURL
                updateUI()
            }
        }
    }
    
    
    struct NotFound {
        static let categoryName = "no type found"
        static let categoryImageURL = "no url found"
    }
    
    var categoryName = NotFound.categoryName
    var categoryImageURL = NotFound.categoryImageURL
    
    private func updateUI() {
        typeLabel.text = categoryName
        typeImageView.image = nil
        updateImage()
        updateAccessoryOptions()
        
    }
    
    private func updateAccessoryOptions() {
        if ((category as? Category) != nil) {
            accessoryType = .disclosureIndicator
        } else if ((category as? Item) != nil) {
            accessoryType = .none
        }
    }
    
    private func updateImage() {
        if let url = URL(string: categoryImageURL) {
            spinner.startAnimating()
            typeImageView.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }
}
