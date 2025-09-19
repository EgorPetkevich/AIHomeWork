//
//  DynamicOverlayView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 8.09.24.
//

import UIKit

class DynamicOverlayView: UIView {

    var transparentRect: CGRect = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let fillColor = UIColor.black.withAlphaComponent(0.4)
        let path = UIBezierPath(rect: self.bounds)
        
        let transparentPath = UIBezierPath(roundedRect: transparentRect, 
                                           cornerRadius: 24.0)
        path.append(transparentPath.reversing())
        
        fillColor.setFill()
        path.fill()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if transparentRect.contains(point) {
            return nil
        }
        return super.hitTest(point, with: event)
    }
}

