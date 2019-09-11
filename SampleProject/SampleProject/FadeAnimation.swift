//
//  FadeAnimation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class FadeAnimation {

    static func fadeInAnimation(_ view: UIView, duration: TimeInterval, delay: TimeInterval) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: { () -> Void in
            view.alpha = 1.0
        }, completion: nil)
    }

    static func fadeOutAnimation(_ view: UIView, duration: TimeInterval, delay: TimeInterval) {
        view.alpha = 1.0
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: { () -> Void in
            view.alpha = 0.0
        }, completion: nil)
    }
}

class SplashScreenAnimation {

    static func splashScreenDuration() -> CGFloat {
        return 0.8
    }

    static func splashScreenDelay() -> CGFloat {
        return 5.1
    }
}

