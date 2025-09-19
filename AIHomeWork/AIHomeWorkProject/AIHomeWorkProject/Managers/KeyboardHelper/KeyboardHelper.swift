//
//  KeyboardHelper.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 4.09.24.
//

import UIKit

final class KeyboardHelper {
    
    typealias KeyboardFrameHandler = (CGRect) -> Void
    
    private var willShow: KeyboardFrameHandler?
    private var didShow: KeyboardFrameHandler?
    private var willHide: KeyboardFrameHandler?
    private var didHide: KeyboardFrameHandler?
    
    init() {
        addObservers()
    }
    
    deinit {
        removeObserers()
    }
    
    private func addObservers() {
        let center = NotificationCenter.default
        
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardDidShow),
                           name: UIResponder.keyboardDidShowNotification,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardDidHide),
                           name: UIResponder.keyboardDidHideNotification,
                           object: nil)
    }
    
    private func removeObserers() {
        let center = NotificationCenter.default
        
        center.removeObserver(self,
                              name: UIResponder.keyboardWillShowNotification,
                              object: nil)
        
        center.removeObserver(self,
                              name: UIResponder.keyboardDidShowNotification,
                              object: nil)
        
        center.removeObserver(self,
                              name: UIResponder.keyboardWillHideNotification,
                              object: nil)
        
        center.removeObserver(self,
                              name: UIResponder.keyboardDidHideNotification,
                              object: nil)
    }
    
    private func frame(from notification: Notification) -> CGRect {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return .zero}

        return frame
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        willShow?(frame(from: notification))
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        didShow?(frame(from: notification))
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        willHide?(frame(from: notification))
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        didHide?(frame(from: notification))
    }
    
    @discardableResult
    func onWillShow(_ handler: @escaping KeyboardFrameHandler) -> Self {
        willShow = handler
        return self
    }
    
    @discardableResult
    func onDidShow(_ handler: @escaping KeyboardFrameHandler) -> Self {
        didShow = handler
        return self
    }
    
    @discardableResult
    func onWillHide(_ handler: @escaping KeyboardFrameHandler) -> Self {
        willHide = handler
        return self
    }
    
    @discardableResult
    func onDidHide(_ handler: @escaping KeyboardFrameHandler) -> Self {
        didHide = handler
        return self
    }
    
}

