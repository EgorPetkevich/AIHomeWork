//
//  UIView+Shadow.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIView {
    
    var shadowColor: CGColor {
        get { layer.shadowColor! }
        set { layer.shadowColor = newValue }
    }
    
    var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
}

