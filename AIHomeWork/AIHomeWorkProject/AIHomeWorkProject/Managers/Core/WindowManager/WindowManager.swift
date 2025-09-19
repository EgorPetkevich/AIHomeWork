//
//  WindowManager.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

final class WindowManager {
    
    enum WindowType {
        case main
        case alert
    }
    
    var rootVC: UIViewController?
    
    private var windows: [WindowType: UIWindow] = [:]
    
    private var scene: UIWindowScene
    
    init(scene: UIWindowScene) {
        self.scene = scene
    }
    
    func get(type: WindowType) -> UIWindow {
        return windows[type] ?? build(type: type)
    }
    
    func show(type: WindowType) {
        let window = get(type: type)
        window.makeKeyAndVisible()
    }
    
    func hide(type: WindowType) {
        let window = get(type: type)
        window.resignKey()
    }
    
    func hideAndRemove(type: WindowType) {
        hide(type: type)
        windows[type] = nil
    }
    
    private func build(type: WindowType) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        windows[type] = window
        return window
    }
    
}
