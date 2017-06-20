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
    var order: Order! {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    @IBOutlet weak var progressBarOutlet: FlexibleSteppedProgressBar!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderedItemsTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBAction func reOrderButtonPressed(_ sender: UIButton) {
    }
    
    
    func updateUI() {
        customizeProgressBar()
        orderIDLabel.text = order.id
        totalPriceLabel.text = "PKR \(order.totalCost)"
        orderedItemsTableView.reloadData()
    }
    
    func customizeProgressBar() {
        progressBarOutlet.translatesAutoresizingMaskIntoConstraints = false
        let rad: CGFloat = 10
        let lineHeight: CGFloat = 2
        
        progressBarOutlet.numberOfPoints = 3
        progressBarOutlet.lineHeight = lineHeight
        progressBarOutlet.radius = rad
        progressBarOutlet.progressRadius = rad * 2
        progressBarOutlet.progressLineHeight = lineHeight * 2
        progressBarOutlet.delegate = self
        progressBarOutlet.stepTextFont = progressBarOutlet.stepTextFont!.withSize(10)
        
        if order.timeStamp?.acceptedAt != nil {
            progressBarOutlet.currentIndex += 1
        }
        
        if order.timeStamp?.delieveredAt != nil {
            progressBarOutlet.currentIndex += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderedItemsTableView.dataSource = self
        if order != nil {
            updateUI()
        }
    }
}

extension OrderDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderedItemTableViewCell", for: indexPath)
        if let itemCell = cell as? OrderedItemTableViewCell {
            itemCell.orderedItem = order.items[indexPath.row]
        }
        return cell
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
                case 0: return o.startedAtTime
                case 1: return o.acceptedAtshortString
                case 2: return o.delieveredAtshortString
                default: break
                }
            }
        }
        
        return ""
    }
}
