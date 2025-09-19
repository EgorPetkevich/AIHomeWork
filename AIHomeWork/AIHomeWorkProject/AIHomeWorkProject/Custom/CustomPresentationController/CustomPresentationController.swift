//
//  CustomPresentationController.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 10.09.24.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        
        let height: CGFloat = 300.0
        let width: CGFloat = containerView.bounds.width
        let x: CGFloat = 0

        let y: CGFloat = containerView.bounds.height - height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
    }
    
}
