//
//  CategoriesTableViewCell.swift
//  OrderUs
//
//  Created by Muhammadali on 17/03/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

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
    
    internal func updateUI() {
        typeLabel.text = categoryName
        typeImageView.image = nil
        updateImage()
        updateAccessoryOptions()
        
    }
    
    internal func updateAccessoryOptions() {
        if ((category as? DataManager.Category) != nil) {
            accessoryType = .disclosureIndicator
        } else if ((category as? DataManager.Item) != nil) {
            accessoryType = .none
        }
    }
    
    internal func updateImage() {
        if let url = NSURL(string: categoryImageURL) {
            spinner.startAnimating()
            DispatchQueue(
                label: "downloading image for \(categoryName)",
                qos: .userInitiated,
                attributes: .concurrent
                ).async {
                    if let imageData = NSData(contentsOf: url as URL) {
                        DispatchQueue.main.async { [weak weakSelf = self] in
                            weakSelf?.spinner.stopAnimating()
                            if weakSelf?.categoryImageURL == url.absoluteString {
                                weakSelf?.typeImageView.image = UIImage(data: imageData as Data)
                            }
                        }
                    }
            }
        }
    }
}
