//
//  LoadingViewController.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet var indicatorViews: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    static func viewController() -> LoadingViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController

        return vc
    }

    func startAnimating() {
        for i in 0 ..< indicatorViews.count * 1000 {
            let view = indicatorViews[i % 3]
            let delay = Double(i) * 0.5
            perform(#selector(changeColor), with: view, afterDelay: delay)
        }
    }

    func stopAnimating() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }

    // MARK: - Private

    fileprivate func setupAppearance() {
        view.backgroundColor = UIColor.white

        loadingLabel.text = "LOADING"
        loadingLabel.textColor = UIColor.darkGray

        indicatorViews.forEach { $0.backgroundColor = UIColor.lightGray }
    }

    @objc fileprivate func changeColor(_ view: UIView) {
        indicatorViews.forEach { $0.backgroundColor = UIColor.lightGray}
        view.backgroundColor = UIColor.white
    }
}
