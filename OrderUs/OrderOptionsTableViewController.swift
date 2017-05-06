//
//  OrderOptionsTableViewController.swift
//  OrderUs
//
//  Created by Muhammad Ali on 2017-04-14.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol OrderOptionsTableViewControllerDelegate {
    func doorStepChanged(selectedOption: OrderOptionsTableViewController.DoorStepOption)
}

class OrderOptionsTableViewController: UITableViewController {
    var delegate: OrderOptionsTableViewControllerDelegate?
    
    enum DoorStepOption {
        case call
        case text
        case ringDoorBell
    }
    
    struct DoorStepOptionStruct {
        let option: DoorStepOption
        let displayText: String
    }
    
    let doorStepOptions: [DoorStepOptionStruct] = [
        DoorStepOptionStruct(option: .ringDoorBell, displayText: "Ring My Doorbell"),
        DoorStepOptionStruct(option: .text, displayText: "Text Me"),
        DoorStepOptionStruct(option: .call, displayText: "Call Me"),
        ]
    
    @IBOutlet weak var doorStepOptionOutlet: UILabel!
    var selectedDoorStepOption: DoorStepOptionStruct?
    internal func showDoorStepOptionsMenu() {
        let optionsMenu = UIAlertController(title: "Choose Your Preference", message: "When at my doorstep, the rider should:", preferredStyle: .actionSheet)
        doorStepOptions.forEach { [unowned uoSelf = self] doorStepOption in
            optionsMenu.addAction(
                UIAlertAction(title: doorStepOption.displayText, style: .default) { _ in
                    uoSelf.selectedDoorStepOption = doorStepOption
                    uoSelf.doorStepOptionOutlet.text = doorStepOption.displayText
                    uoSelf.delegate?.doorStepChanged(selectedOption: doorStepOption.option)
                }
            )
        }
        optionsMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(optionsMenu, animated: true, completion: nil)
    }
    
//    @IBOutlet weak var paymentOptionOutlet: UILabel!
//    let paymentOptions: [DoorStepOptionStruct] = [
//        DoorStepOptionStruct(option: .ringDoorBell, displayText: "Ring My Doorbell"),
//        DoorStepOptionStruct(option: .text, displayText: "Text Me"),
//        DoorStepOptionStruct(option: .call, displayText: "Call Me"),
//        ]
//    
//
//    var selectedPaymentOption: DoorStepOptionStruct?
//    internal func showPaymentOptionsMenu() {
//        let optionsMenu = UIAlertController(title: "Choose Your Preference", message: "When at my doorstep, the rider should:", preferredStyle: .actionSheet)
//        doorStepOptions.forEach { [unowned uoSelf = self] doorStepOption in
//            optionsMenu.addAction(
//                UIAlertAction(title: doorStepOption.displayText, style: .default) { _ in
//                    uoSelf.selectedDoorStepOption = doorStepOption
//                    uoSelf.doorStepOptionOutlet.text = doorStepOption.displayText
//                    uoSelf.delegate?.doorStepChanged(selectedOption: doorStepOption.option)
//                }
//            )
//        }
//        optionsMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(optionsMenu, animated: true, completion: nil)
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            showDoorStepOptionsMenu()
        case 1:
            break
            //showPaymentOptionsMenu()
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDoorStepOption = doorStepOptions[0]
        doorStepOptionOutlet.text = selectedDoorStepOption?.displayText
    }
    
    
}
