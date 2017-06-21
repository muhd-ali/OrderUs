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
            if order != nil {
                orderDetails = extractOrderDetails(from: order)
                if isViewLoaded {
                    updateUI()
                }
            }
        }
    }
    
    internal var orderDetails = [(name: String, value: String)]()
    private func extractOrderDetails(from order: Order) -> [(name: String, value: String)] {
        var details = [(name: String, value: String)]()
        details.append((name: "Order ID:", value: order.id))
        if order.assignedTo != nil {
            details.append((name: "Rider:", value: "Name: \(order.assignedTo!.name)"))
        }
        if order.location != nil {
            details.append((name: "Address:", value: order.location!.address))
        }
        details.append((name: "Total:", value: "PKR \(order.totalCost)"))
        return details
    }
    
    @IBOutlet weak var progressBarOutlet: FlexibleSteppedProgressBar!
    @IBOutlet weak var orderDetailsTableView: UITableView!
    @IBOutlet weak var orderedItemsTableView: UITableView!
    @IBAction func reOrderButtonPressed(_ sender: UIButton) {
    }
    
    
    func updateUI() {
        orderedItemsTableView.reloadData()
        orderDetailsTableView.reloadData()
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
        orderDetailsTableView.dataSource = self
        orderDetailsTableView.estimatedRowHeight = orderDetailsTableView.rowHeight
        orderDetailsTableView.rowHeight = UITableViewAutomaticDimension
        initializeProgressBar()
        if order != nil {
            updateUI()
        }
    }
}

extension OrderDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView.tag {
        case 1:
            return orderDetails.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 1:
            return 1
        case 2:
            return order.items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
            if let textView = cell.viewWithTag(1) as? UITextView {
                textView.text = orderDetails[indexPath.section].value
                let contentSize = textView.sizeThatFits(textView.bounds.size)
                var frame = textView.frame
                frame.size.height = contentSize.height
                textView.frame = frame
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderedItemTableViewCell", for: indexPath)
            if let itemCell = cell as? OrderedItemTableViewCell {
                itemCell.orderedItem = order.items[indexPath.row]
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView.tag {
        case 1:
            return orderDetails[section].name
        default:
            return nil
        }
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
