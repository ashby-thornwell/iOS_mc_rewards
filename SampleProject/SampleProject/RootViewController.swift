//
//  RootViewController.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var tabBar: RootTabBarController?

    lazy var modelController: RootModelController = RootModelController()

    fileprivate enum Segue: String {
        case RootTabBarEmbedSegue = "RootTabBarEmbedSegue"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let segueId = Segue(rawValue:identifier) else { return }
        
        switch segueId {
        case .RootTabBarEmbedSegue:
            if let tabBarVC = segue.destination as? RootTabBarController {
                tabBar = tabBarVC

                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    modelController.bootstrapper = appDelegate.bootstrapper
                }
                tabBarVC.store = modelController.bootstrapper?.store
            }
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}


