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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    var category: [String:Any]? {
        didSet {
            categoryType = (category?["Type"] as? String) ?? NotFound.categoryType
            categoryDescription = (category?["Description"] as? String) ?? NotFound.categoryDescription
            categoryImageURL = (category?["ImageURL"] as? String) ?? NotFound.categoryImageURL
            updateUI()
        }
    }
    
    
    struct NotFound {
        static let categoryType = "no type found"
        static let categoryDescription = "no description found"
        static let categoryImageURL = "no url found"
    }
    
    var categoryType = NotFound.categoryType
    var categoryDescription = NotFound.categoryDescription
    var categoryImageURL = NotFound.categoryImageURL
    
    private func updateUI() {
        typeLabel.text = categoryType
        descriptionLabel.text = categoryDescription
        if let url = NSURL(string: categoryImageURL) {
            spinner.startAnimating()
            typeImageView.image = nil
            DispatchQueue(
                label: "downloading image for \(typeLabel.text)",
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
