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


    
    var category: [String:String]? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        typeLabel.text = category?["Type"]
        descriptionLabel.text = category?["Examples"]
        
        if let urlStr = category?["image"] {
            if let url = NSURL(string: urlStr) {
                let newThread = DispatchQueue(label: "image for \(typeLabel.text)", qos: .userInitiated, attributes: .concurrent)
                newThread.async {
                    if let imageData = NSData(contentsOf: url as URL) {
                        typeImageView.image = UIImage(data: imageData as Data)
                    }
                }
            }
        }
    }
}
