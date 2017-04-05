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
            updateUI()
        }
    }
    
    private func updateUI() {
        typeLabel.text = category?["Type"] as? String
        descriptionLabel.text = category?["Examples"] as? String
        
        if let urlStr = category?["image"] as? String {
            if let url = NSURL(string: urlStr) {
                let newThread = DispatchQueue(label: "image for \(typeLabel.text)", qos: .userInitiated, attributes: .concurrent)
                spinner.startAnimating()
                newThread.async {
                    if let imageData = NSData(contentsOf: url as URL) {
                        DispatchQueue.main.async { [weak weakSelf = self] in
                            weakSelf?.typeImageView.image = UIImage(data: imageData as Data)
                            weakSelf?.spinner.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}
