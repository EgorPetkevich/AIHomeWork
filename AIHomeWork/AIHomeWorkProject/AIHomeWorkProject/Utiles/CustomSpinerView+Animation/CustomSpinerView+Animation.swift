//
//  CustomSpinerView+Animation.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 11.09.24.
//

import Foundation

extension CustomSpinerView {
    
    @discardableResult
    func start() -> CustomSpinerView {
        self.startAnimating()
        return self
    }
    
    @discardableResult
    func stop() -> CustomSpinerView {
        self.stopAnimating()
        return self
    }
    
}
