//
//  SideMenuTableViewController.swift
//  OrderUs
//
//  Created by Muhammadali on 05/06/2017.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol SideMenuTableViewControllerDelegate {
    func sideMenuDidAppear()
    func sideMenuWillDisappear()
}

class SideMenuTableViewController: UITableViewController {
    
    static var delegate: SideMenuTableViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SideMenuTableViewController.delegate?.sideMenuDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SideMenuTableViewController.delegate?.sideMenuWillDisappear()
    }

}
