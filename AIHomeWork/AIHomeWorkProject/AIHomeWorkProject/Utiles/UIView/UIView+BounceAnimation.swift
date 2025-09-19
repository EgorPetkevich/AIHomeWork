//
//  UIView+BounceAnimation.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIView {
    
    func bounceAnimation(duration: TimeInterval = 1.0,
                              fromValue: CGFloat = 1.0,
                              toValue: CGFloat = 1.05) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = fromValue
        pulseAnimation.toValue = toValue
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        
        self.layer.add(pulseAnimation, forKey: "bounce")
    }
    
}
