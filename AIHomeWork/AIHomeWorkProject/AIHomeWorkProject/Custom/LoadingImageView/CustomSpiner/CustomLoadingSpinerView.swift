//
//  CustomLoadingSpinerView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 19.09.24.
//

import UIKit

import UIKit

class CustomLoadingSpinnerView: UIView {

    private let spinnerLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    var progress: CGFloat = 0 {
        didSet {
            updateSpinnerPath()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupXMark()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        setupXMark()
    }

    private func setupLayers() {
        let lineWidth: CGFloat = 4
        let radius = (min(bounds.width, bounds.height) / 2) - lineWidth

        let backgroundPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                          radius: radius,
                                          startAngle: -CGFloat.pi / 2,
                                          endAngle: 1.5 * CGFloat.pi,
                                          clockwise: true)
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = UIColor.gray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round
        self.layer.addSublayer(backgroundLayer)

        spinnerLayer.strokeColor = UIColor.white.cgColor
        spinnerLayer.fillColor = UIColor.clear.cgColor
        spinnerLayer.lineWidth = lineWidth
        spinnerLayer.lineCap = .round
        spinnerLayer.strokeEnd = 0
        self.layer.addSublayer(spinnerLayer)
    }

    private func updateSpinnerPath() {
        let radius = (min(bounds.width, bounds.height) / 2) - spinnerLayer.lineWidth
        let startAngle: CGFloat = -CGFloat.pi / 2
        let endAngle: CGFloat = startAngle + (2 * CGFloat.pi * progress)

        let spinnerPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                       radius: radius,
                                       startAngle: startAngle,
                                       endAngle: endAngle,
                                       clockwise: true)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = spinnerLayer.strokeEnd
        animation.toValue = progress
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        spinnerLayer.strokeEnd = progress
        spinnerLayer.path = spinnerPath.cgPath
        spinnerLayer.add(animation, forKey: "animateProgress")
    }

    private func setupXMark() {
        let xMarkImageView: UIImageView = UIImageView(image: .appiconWhiteXmark)
        xMarkImageView.tintColor = .white
        self.addSubview(xMarkImageView)
        xMarkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(12.0)
        }
    }

    func startAnimating() {
        isHidden = false
        progress = 0
    }

    func stopAnimating() {
        isHidden = true
        progress = 0
        spinnerLayer.removeAllAnimations()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
}
