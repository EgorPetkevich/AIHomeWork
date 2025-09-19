//
//  ScanningFrameView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 8.09.24.
//

import UIKit

protocol ScanningFrameViewDelegate: AnyObject {
    func scanningFrameViewDidUpdate(_ scanningFrameView: ScanningFrameView)
}

class ScanningFrameView: UIView {
    
    weak var delegate: ScanningFrameViewDelegate?
    
    private let resizeButton = UIButton(type: .system)
    private var parentBounds: CGRect {
        return superview?.bounds ?? .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        resizeButton.setImage(
            UIImage(systemName: "arrow.up.left.and.arrow.down.right"),
            for: .normal)
        resizeButton.tintColor = .appWhite
        resizeButton.backgroundColor = .appActive
       
        addSubview(resizeButton)
        
        addGestureRecognizer(
            UIPanGestureRecognizer(target: self,
                                   action: #selector(handlePanGesture)))
        resizeButton.addGestureRecognizer(
            UIPanGestureRecognizer(target: self,
                                   action: #selector(handleResizePanGesture)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeButton.frame = CGRect(x: bounds.width - 25,
                                    y: bounds.height - 25,
                                    width: 36, height: 36)
        resizeButton.layer.masksToBounds = true
        resizeButton.cornerRadius = resizeButton.bounds.height / 2
        resizeButton.layer.zPosition = .greatestFiniteMagnitude
        self.cornerRadius = 24.0
        delegate?.scanningFrameViewDidUpdate(self)

        
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        let translation = gesture.translation(in: superview)
        if let view = gesture.view {
            var newCenter = CGPoint(x: view.center.x + translation.x,
                                    y: view.center.y + translation.y)
            
            let halfWidth = view.bounds.width / 2
            let halfHeight = view.bounds.height / 2
            
            newCenter.x = max(halfWidth, newCenter.x)
            newCenter.x = min(superview.bounds.width - halfWidth, newCenter.x)
            
            newCenter.y = max(halfHeight, newCenter.y)
            newCenter.y = min(superview.bounds.height - halfHeight, newCenter.y)
            
            view.center = newCenter
            gesture.setTranslation(.zero, in: superview)
            delegate?.scanningFrameViewDidUpdate(self)
        }
    }
    
    @objc private func handleResizePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        guard let view = gesture.view?.superview else { return }
        
        let translation = gesture.translation(in: superview)
        
        var newWidth = view.frame.width + translation.x
        var newHeight = view.frame.height + translation.y
        
        newWidth = max(100, newWidth)
        newHeight = max(100, newHeight)
        
        newWidth = min(newWidth, superview.bounds.width - view.frame.minX)
        newHeight = min(newHeight, superview.bounds.height - view.frame.minY)
        
        view.frame.size = CGSize(width: newWidth, height: newHeight)
        
        gesture.setTranslation(.zero, in: superview)
        delegate?.scanningFrameViewDidUpdate(self)
    }


}
