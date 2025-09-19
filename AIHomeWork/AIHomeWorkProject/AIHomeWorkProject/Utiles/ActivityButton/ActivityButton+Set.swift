//
//  ActivityButton+Set.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.08.24.
//

extension ActivityButton {
    
    @discardableResult
    func startBounceAnimation() -> ActivityButton {
        self.bounceAnimation()
        return self
    }
    
    func strartActivityAnimation() {
        self.isEnabled(false)
        self.isArrowImageViewHidden(true)
        self.activityIndicator.startAnimating()
    }
    
    func stopActivityAnimation() {
        self.isArrowImageViewHidden(false)
        self.isEnabled(true)
        self.activityIndicator.stopAnimating()
    }
    
    @discardableResult
    func isEnabled(_ value: Bool) -> ActivityButton {
        self.buttonisEnabled = value
        return self
    }
    
    @discardableResult
    func isArrowImageViewHidden(_ value: Bool) -> ActivityButton {
        self.isArrowImageViewHidden = value
        return self
    }
    
    @discardableResult
    func setTitle(_ text: String) -> ActivityButton {
        self.setTitle = text
        return self
    }
    
    @discardableResult
    func setPaywallRevTitle(_ text: String) -> ActivityButton {
        self.setPaywallRevTitle = text
        return self
    }
    
}
