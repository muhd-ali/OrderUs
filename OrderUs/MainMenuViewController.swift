//
//  MainMenuViewController.swift
//  OrderUs
//
//  Created by muaz hamza on 2017-05-03.
//  Copyright © 2017 PRO. All rights reserved.
//

import UIKit

protocol MainMenuViewControllerCurrentActive {
    func homeButtonPressed()
}

class MainMenuViewController: UITabBarController {
    var active: MainMenuViewControllerCurrentActive?
    
    struct Constants {
        static let appTintColor = UIColor(red: 244/255, green: 124/255, blue: 32/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Constants.appTintColor
        addHomeButton()
    }
    
    private let animationDuration: TimeInterval = 0.2
    private var homeButtonContainer: UIView!
    private var homeButton: UIButton!
    
    private func addHomeButton() {
        let buttonContainerSideLength: CGFloat = tabBar.bounds.height
        let buttonContainerFrameInTabBar = CGRect(
            x: tabBar.bounds.midX - (buttonContainerSideLength / 2),
            y: tabBar.bounds.midY - (buttonContainerSideLength / 2),
            width: buttonContainerSideLength,
            height: buttonContainerSideLength
        )
        let buttonContainerFrameInWorld = tabBar.convert(buttonContainerFrameInTabBar, to: view)
        homeButtonContainer = UIView(frame: buttonContainerFrameInWorld)
        homeButtonContainer.backgroundColor = Constants.appTintColor
        view.addSubview(homeButtonContainer)
        
        
        
        let buttonSideLength: CGFloat = 0.9 * buttonContainerSideLength
        let buttonFrameInContainer = CGRect(
            x: homeButtonContainer.bounds.midX - (buttonSideLength / 2),
            y: homeButtonContainer.bounds.midY - (buttonSideLength / 2),
            width: buttonSideLength,
            height: buttonSideLength
        )
        homeButton = UIButton(frame: buttonFrameInContainer)
        homeButton.contentHorizontalAlignment = .center
        homeButton.contentVerticalAlignment = .center
        homeButton.setImage(#imageLiteral(resourceName: "app-logo"), for: .normal)
        homeButton.adjustsImageWhenHighlighted = true
        homeButton.addTarget(self, action: #selector(homeButtonPressed(sender:)), for: .touchUpInside)
        homeButtonContainer.addSubview(homeButton)
    }
    
    func homeButtonPressed(sender: UIButton) {
        active?.homeButtonPressed()
    }
    
    private func applyYOffsetToTabBar(yOffset: CGFloat) {
        tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: yOffset)
        homeButton.frame = homeButton.frame.offsetBy(dx: 0, dy: yOffset)
        homeButtonContainer.frame = homeButtonContainer.frame.offsetBy(dx: 0, dy: yOffset)
    }
    
    private func applyHideOffsetToTabBar() {
        applyYOffsetToTabBar(yOffset: tabBar.frame.height)
    }
    
    private func applyShowOffsetToTabBar() {
        applyYOffsetToTabBar(yOffset: -tabBar.frame.height)
    }
    
    private func setIsHiddenOfTabBar(hidden: Bool) {
        tabBar.isHidden = hidden
        homeButton.isHidden = hidden
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
