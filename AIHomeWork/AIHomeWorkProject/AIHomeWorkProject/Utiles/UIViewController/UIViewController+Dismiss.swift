//
//  UIViewController+Dismiss.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIViewController {
    
    @discardableResult
    func dismissDetail() -> UIViewController {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
        return self
    }
    
    @discardableResult
    func dismissDetailRight() -> UIViewController {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
        return self
    }
    
}
