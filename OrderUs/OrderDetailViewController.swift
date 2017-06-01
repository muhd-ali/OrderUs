//
//  OrderDetailViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 29/05/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar

class OrderDetailViewController: UIViewController {
    var order: OrdersModel.Order?
    
    @IBOutlet weak var progressBarOutlet: FlexibleSteppedProgressBar!
    @IBOutlet weak var orderIDOutlet: UITextView!
    
    func updateUI() {
        customizeProgressBar()
        orderIDOutlet.text = "Order ID: \(order?.id ?? "")"
    }
    
    func customizeProgressBar() {
        progressBarOutlet.translatesAutoresizingMaskIntoConstraints = false
        let viewHeight = progressBarOutlet.bounds.height
        let rad = viewHeight / 10
        let lineHeight = viewHeight / 40
        
        progressBarOutlet.numberOfPoints = 3
        progressBarOutlet.lineHeight = lineHeight
        progressBarOutlet.radius = rad
        progressBarOutlet.progressRadius = rad * 2
        progressBarOutlet.progressLineHeight = lineHeight * 2
        progressBarOutlet.delegate = self
        
        if order?.timeStamp?.acceptedAt != nil {
            progressBarOutlet.currentIndex += 1
        }
        
        if order?.timeStamp?.delieveredAt != nil {
            progressBarOutlet.currentIndex += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
}

extension OrderDetailViewController: FlexibleSteppedProgressBarDelegate {
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, didSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, canSelectItemAtIndex index: Int) -> Bool {
        return false
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar, textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.top {
            switch index {
            case 0: return "Started at"
            case 1: return "Accepted at"
            case 2: return "Delievered at"
            default: break
            }
        }
        
        
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            if let o = order {
                switch index {
                case 0: return o.startedAtshortString
                case 1: return o.acceptedAtshortString
                case 2: return o.delieveredAtshortString
                default: break
                }
            }
        }
        
        return ""
    }
}
