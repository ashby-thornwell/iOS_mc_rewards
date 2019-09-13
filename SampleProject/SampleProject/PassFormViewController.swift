//
//  PassFormViewController.swift
//  SampleProject
//
//  Created by Ashby Thornwell on 9/11/19.
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class PassFormViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var couponTitleTextField: UITextField!
    @IBOutlet weak var couponDescriptionTextField: UITextField!
    @IBOutlet weak var couponDatePicker: UIDatePicker!
    @IBOutlet weak var couponTextColorButton: UIButton!
    
    var textSelectColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Build a Reward"
    }
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
    @IBAction func textButtonTapped(_ sender: UIButton) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    func setButtonColor (_ color: UIColor) {
        couponTextColorButton.setTitleColor(color, for: UIControlState())
    }
}
