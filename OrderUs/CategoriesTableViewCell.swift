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
        if let url = NSURL(string: categoryImageURL) {
            spinner.startAnimating()
            DispatchQueue(
                label: "downloading image for \(categoryName)",
                qos: .userInitiated,
                attributes: .concurrent
                ).async {
                    if let imageData = NSData(contentsOf: url as URL) {
                        DispatchQueue.main.async { [unowned uoSelf = self] in
                            uoSelf.spinner.stopAnimating()
                            if uoSelf.categoryImageURL == url.absoluteString {
                                uoSelf.typeImageView.image = UIImage(data: imageData as Data)
                            }
                        }
                    }
            }
        }
    }
}
