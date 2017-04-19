//
//  OrderOptionsTableViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-04-14.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

class OrderOptionsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    enum doorStepOption {
        case call
        case text
        case pushNotify
        case ringDoorBell
    }
    
    struct doorStepOptionStruct {
        let option: doorStepOption
        let displayText: String
    }
    
    let doorStepOptionStructs: [doorStepOptionStruct] = [
        doorStepOptionStruct(option: .pushNotify, displayText: "Send Push Notification"),
        doorStepOptionStruct(option: .ringDoorBell, displayText: "Ring My Doorbell"),
        doorStepOptionStruct(option: .call, displayText: "Call Me"),
        doorStepOptionStruct(option: .text, displayText: "Text Me"),
        ]
    @IBOutlet weak var optionsPicker: UIPickerView!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return doorStepOptionStructs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return doorStepOptionStructs[row].displayText
    }
    
    @IBOutlet weak var doorStepOptionOutlet: UILabel!
    var selectedDoorStepOption = 0
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDoorStepOption = row
        doorStepOptionOutlet.text = doorStepOptionStructs[selectedDoorStepOption].displayText
    }
    
    func toggleOptionPickerVisibility() {
        UIView.transition(
            with: optionsPicker,
            duration: 0.5,
            options: [.curveEaseInOut, .transitionFlipFromTop],
            animations: { [unowned uoSelf = self] in
                if uoSelf.optionsPicker.isHidden {
                    uoSelf.optionsPicker.isHidden = false
                } else {
                    uoSelf.optionsPicker.isHidden = true
                }
        },
            completion: nil
        )
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            toggleOptionPickerVisibility()
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        optionsPicker.dataSource = self
        optionsPicker.delegate = self
        doorStepOptionOutlet.text = doorStepOptionStructs[selectedDoorStepOption].displayText
    }
    
    
}
