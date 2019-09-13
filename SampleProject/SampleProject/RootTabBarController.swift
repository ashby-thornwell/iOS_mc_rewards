//
//  RootTabBarController.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

struct RootTabBarControllerConstants {
    static let rewards = "Rewards"
    static let build = "Build"
}

class RootTabBarController: UITabBarController {

    var store: Store?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBorderView()
        setupTabBarViewControllers()
    }

    func setUpBorderView() {
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = UIColor.gray
        tabBar.addSubview(borderView)

        NSLayoutConstraint(item: borderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0).isActive = true
        NSLayoutConstraint(item: borderView, attribute: .width, relatedBy: .equal, toItem: tabBar, attribute: .width, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: borderView, attribute: .top, relatedBy: .equal, toItem: tabBar, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    func setupTabBarViewControllers() {
        if let navigationController = navigationController {
            navigationController.isNavigationBarHidden = true
        }
        
        let buildTabItem = UITabBarItem()
        buildTabItem.title = "Build Rewards"
        buildTabItem.image = UIImage(named: "Build Icon")
        
        let buildStoryboard = UIStoryboard(name: "PassForm", bundle: nil)
        let buildViewController = buildStoryboard.instantiateInitialViewController() as! PassFormViewController
        buildViewController.tabBarItem = buildTabItem
        let buildNavigationController = UINavigationController(rootViewController: buildViewController)
        
        let rewardTabItem = UITabBarItem()
        rewardTabItem.title = "View Rewards"
        rewardTabItem.image = UIImage(named: "Reward Icon")
        
        let rewardStoryboard = UIStoryboard(name: RootTabBarControllerConstants.rewards, bundle: nil)
        let rewardViewController = rewardStoryboard.instantiateInitialViewController() as! RewardsViewController
        rewardViewController.tabBarItem = rewardTabItem
        let rewardNavigationController = UINavigationController(rootViewController: rewardViewController)

        
        let validateTabItem = UITabBarItem()
        validateTabItem.title = "Validate Rewards"
        validateTabItem.image = UIImage(named: "Validate Icon")
        
        let validateViewController = ValidationViewController()
        validateViewController.tabBarItem = validateTabItem
        let validateNavigationController = UINavigationController(rootViewController: validateViewController)

        setViewControllers([buildNavigationController, rewardNavigationController, validateNavigationController], animated: false)

        tabBar.tintColor = .tabItemBlue()
        
        tabBar.barTintColor = .white
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.tabItemBlue()], for: .selected)
    }
}
