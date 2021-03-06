//
//  ResultPathCollectionViewCell.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-06-19.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class ResultPathCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pathCellImageView: UIImageView!
    @IBOutlet weak var pathCellLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var selectable: Selectable! {
        didSet {
            if selectable != nil {
                updateUI()
            }
        }
    }
    
    func updateUI() {
        pathCellLabel.text = selectable.Name
        updateImage()
    }
    
    private func updateImage() {
        spinner.startAnimating()
        selectable.applyImage(to: pathCellImageView) { [unowned uoSelf = self] in
            uoSelf.spinner.stopAnimating()
        }
    }
}
