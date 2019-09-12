//
//  BuildRewardViewController.swift
//  SampleProject
//
//  Created by Ashby Thornwell on 9/10/19.
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class BuildRewardViewController: UIViewController {
    @IBOutlet weak var couponContainerView: UIView!
    @IBOutlet weak var eventContainerView: UIView!
    @IBOutlet weak var loyaltyCardContainerView: UIView!
    @IBOutlet weak var businessCardContainerView: UIView!
    
    @IBAction func createCoupon(_ sender: Any) {
        print("Create coupon button tapped.")
    }
    
    @IBAction func createEvent(_ sender: Any) {
        print("Create event button tapped.")
    }
    
    @IBAction func createBusinessCard(_ sender: Any) {
        print("Create business card button tapped.")
    }
    
    @IBAction func createLoyaltyCard(_ sender: Any) {
        print("Create loyalty card button tapped.")
    }
    
    func addBorderToContainerView(container: UIView) {
        // Clear background color.
        container.backgroundColor = UIColor.clear
        
        // Set corner radius.
        container.layer.cornerRadius = 10
        
        // Set border width.
        container.layer.borderWidth = 5
        
        // Set border color.
        container.layer.borderColor = UIColor.tabItemBlue().cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Build"
        
        addBorderToContainerView(container: couponContainerView)
        addBorderToContainerView(container: eventContainerView)
        addBorderToContainerView(container: loyaltyCardContainerView)
        addBorderToContainerView(container: businessCardContainerView)
        
        let tapCoupon = UITapGestureRecognizer(target: self, action: #selector(self.createCoupon(_:)))
        couponContainerView.addGestureRecognizer(tapCoupon)
        
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(self.createEvent(_:)))
        eventContainerView.addGestureRecognizer(tapEvent)
        
        let tapLoyaltyCard = UITapGestureRecognizer(target: self, action: #selector(self.createLoyaltyCard(_:)))
        loyaltyCardContainerView.addGestureRecognizer(tapLoyaltyCard)
        
        let tapBusinessCard = UITapGestureRecognizer(target: self, action: #selector(self.createBusinessCard(_:)))
        businessCardContainerView.addGestureRecognizer(tapBusinessCard)
    }
}
