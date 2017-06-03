//
//  MiddleCategoriesTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 02/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class MiddleCategoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var categoryNameOutlet: UILabel!
    @IBOutlet weak var directionArrowOutlet: UILabel!
    
    var controller: MiddleCategoriesTableViewController?
    var indexSection: Int?
    private var isSelectedSection = false
    
    var categoryImageURL = ""
    var categoryName = ""
    var category: Category? {
        didSet {
            if category != nil {
                categoryImageURL = category!.ImageURL
                categoryName = category!.Name
                addGestureRecognizer()
                updateUI()
            }
        }
    }
    
    func addGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(recognizer)
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        controller?.didSelectSection(at: indexSection)
        isSelectedSection = isSelectedSection ? false : true
        var rotation: CGFloat = 0
        if isSelectedSection {
            rotation = CGFloat(Double.pi / 2)
        }
        directionArrowOutlet.layer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
    }
    
    func updateUI() {
        categoryNameOutlet.text = categoryName
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
