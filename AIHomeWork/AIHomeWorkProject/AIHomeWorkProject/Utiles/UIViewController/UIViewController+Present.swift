//
//  UIViewController+Present.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController,
                       _ duration: CFTimeInterval = 0.25) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
}
