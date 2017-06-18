//
//  MiddleSuperCategoryView.swift
//  OrderUs
//
//  Created by Muhammadali on 04/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class MiddleSuperCategoryView: UITableViewHeaderFooterView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var accessoryArrow: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var controller: MiddleCategoriesTableViewController?
    var indexSection: Int?
    var isSelectedSection = false {
        didSet {
            if category?.ChildrenCategories.count ?? 0 > 0 {
                var rotation: CGFloat = 0
                if isSelectedSection {
                    rotation = CGFloat(Double.pi / 2)
                }
                accessoryArrow.layer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
            }
        }
    }
    
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
    }
    
    func updateUI() {
        label.text = categoryName
        updateImage()
    }
    
    func updateImage() {
        if let url = URL(string: categoryImageURL) {
            spinner.startAnimating()
            imageView.sd_setImage(with: url) { [unowned uoSelf = self] (uiImage, error, cacheType, url) in
                uoSelf.spinner.stopAnimating()
            }
        }
    }

}
