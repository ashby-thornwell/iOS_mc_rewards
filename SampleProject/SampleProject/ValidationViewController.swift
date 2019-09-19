//
//  ValidationViewController.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class ValidationViewController: UIViewController {
    
    @objc func scan(sender: UIButton!) {
        let validationScannerVC = ValidationScannerViewController()
        self.navigationController?.pushViewController(validationScannerVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Validate"
        self.view.backgroundColor = UIColor.tabItemBlue()
        
        let qrScanIcon = UIImage(named: "QR Scan Icon")
        let scanButton = UIButton(frame: CGRect(x: 100, y: 100, width: 300, height: 300))
        scanButton.center = self.view.center
        scanButton.setImage(qrScanIcon, for: .normal)
        scanButton.addTarget(self, action: #selector(self.scan), for: .touchUpInside)
        self.view.addSubview(scanButton)

    }
}
