//
//  MainMenuViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-05-03.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit


class MainMenuViewController: UITabBarController {
    struct Constants {
        static let appTintColor = UIColor(red: 244/255, green: 124/255, blue: 32/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.green
        tabBar.items?.forEach{ (item)in
//            item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: .normal)
            item.image = item.image?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    private let animationDuration: TimeInterval = 0.2
    
    private func applyYOffsetToTabBar(yOffset: CGFloat) {
        tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: yOffset)
    }
    
    private func applyHideOffsetToTabBar() {
        applyYOffsetToTabBar(yOffset: tabBar.frame.height)
    }
    
    private func applyShowOffsetToTabBar() {
        applyYOffsetToTabBar(yOffset: -tabBar.frame.height)
    }
    
    private func setIsHiddenOfTabBar(hidden: Bool) {
        tabBar.isHidden = hidden
    }
    
    private func setIsHiddenOfTabBarToFalse() {
        setIsHiddenOfTabBar(hidden: false)
    }
    
    private func setIsHiddenOfTabBarToTrue() {
        setIsHiddenOfTabBar(hidden: true)
    }
    
    func hideTabBar(animated: Bool) {
        if animated {
            UIView.animate(withDuration: animationDuration, animations: { [unowned uoSelf = self] in
                uoSelf.applyHideOffsetToTabBar()
            }) { [unowned uoSelf = self] (completed) in
                if completed {
                    uoSelf.setIsHiddenOfTabBarToTrue()
                }
            }
        } else {
            applyHideOffsetToTabBar()
            setIsHiddenOfTabBarToTrue()
        }
    }
    
    func showTabBar(animated: Bool) {
        if animated {
            setIsHiddenOfTabBarToFalse()
            
            UIView.animate(withDuration: animationDuration) { [unowned uoSelf = self] in
                uoSelf.applyShowOffsetToTabBar()
            }
        } else {
            setIsHiddenOfTabBarToFalse()
            applyShowOffsetToTabBar()
        }
    }
}
