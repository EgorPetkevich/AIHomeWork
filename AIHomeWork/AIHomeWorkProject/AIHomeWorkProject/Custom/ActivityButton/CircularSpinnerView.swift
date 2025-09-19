//
//  CircularSpinnerView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit

class CircularSpinnerView: UIView {

    private let backgroundLayer = CAShapeLayer()
    private let spinnerLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    init() {
        super.init(frame: .zero)
        setupLayers()
        self.isHidden = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        let radius: CGFloat = 12
        let lineWidth: CGFloat = 4
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        let backgroundPath = UIBezierPath(arcCenter: centerPoint,
                                          radius: radius,
                                          startAngle: 0,
                                          endAngle: 2 * CGFloat.pi,
                                          clockwise: true)
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = UIColor.appGrey.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = lineWidth
        self.layer.addSublayer(backgroundLayer)

        let spinnerPath = UIBezierPath(arcCenter: centerPoint, 
                                       radius: radius,
                                       startAngle: 0,
                                       endAngle: CGFloat.pi / 0.75,
                                       clockwise: true)
        spinnerLayer.path = spinnerPath.cgPath
        spinnerLayer.strokeColor = UIColor.appBlack.cgColor
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineWidth = lineWidth
        spinnerLayer.lineCap = .round
        self.layer.addSublayer(spinnerLayer)
    }

    func startAnimating() {
        isHidden = false
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.repeatCount = .infinity

        spinnerLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    func stopAnimating() {
        isHidden = true
        spinnerLayer.removeAllAnimations()
    }
}
