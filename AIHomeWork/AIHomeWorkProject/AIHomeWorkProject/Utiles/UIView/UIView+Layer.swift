//
//  UIView+Layer.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    func setShadow(_ width: CGFloat = 0.0,
                   _ height: CGFloat = 0.0,
                   _ color: UIColor = .appBlack,
                   _ radius: CGFloat = 3.0,
                   _ opacity: Float = 0.08
                   )
    {
        layer.shadowOffset = CGSize(width: width, height: height)
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func roundCornersExeptBottomLeft(cornerRadius: CGFloat) {
        self.cornerRadius = 4
        layer.masksToBounds = true
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.bottomRight, .topRight, .topLeft],
            cornerRadii: CGSize(width: cornerRadius,
                                height: 0.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func roundCornersExeptBottomRight(cornerRadius: CGFloat) {
        self.cornerRadius = 4
        layer.masksToBounds = true
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.bottomLeft, .topRight, .topLeft],
            cornerRadii: CGSize(width: cornerRadius,
                                height: 0.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
}

