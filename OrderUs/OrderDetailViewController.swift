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
        orderIDLabel.text = order.id
        totalPriceLabel.text = "PKR \(order.totalCost)"
        orderedItemsTableView.reloadData()
    }
    
    private func initializeProgressBar() {
        progressBarOutlet.translatesAutoresizingMaskIntoConstraints = false
        let rad: CGFloat = 10
        let lineHeight: CGFloat = 2
        
        progressBarOutlet.numberOfPoints = 4
        progressBarOutlet.lineHeight = lineHeight
        progressBarOutlet.radius = rad
        progressBarOutlet.progressRadius = rad * 2
        progressBarOutlet.progressLineHeight = lineHeight * 2
        progressBarOutlet.delegate = self
        progressBarOutlet.stepTextFont = progressBarOutlet.stepTextFont!.withSize(10)
        progressBarOutlet.stepAnimationDuration = 0.2
    }
    
    private func updateProgressBar() {
        progressBarOutlet.currentIndex = 0

        if order.isAccepted {
            progressBarOutlet.currentIndex += 1
        }
        
        if order.isAcknowledged {
            progressBarOutlet.currentIndex += 1
        }

        if order.isDelievered {
            progressBarOutlet.currentIndex += 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgressBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderedItemsTableView.dataSource = self
        initializeProgressBar()
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
            case 0: return "Started"
            case 1: return "Received"
            case 2: return "Accepted"
            case 3: return "Delievered"
            default: break
            }
        }
        
        
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            if let o = order {
                switch index {
                case 0: return o.timeStamp?.startedAt.shortTime ?? ""
                case 1: return o.timeStamp?.acknowledgedAt?.shortTime ?? ""
                case 2: return o.timeStamp?.acceptedAt?.shortTime ?? ""
                case 3: return o.timeStamp?.delieveredAt?.shortTime ?? ""
                default: break
                }
            }
        }
        
        return ""
    }
}
