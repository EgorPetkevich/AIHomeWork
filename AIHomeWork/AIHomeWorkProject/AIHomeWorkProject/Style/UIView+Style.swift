//
//  UIView+Style.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.08.24.
//

import UIKit

extension UIView {
    
    static func contentView() -> UIView {
        let view = UIView()
        view.backgroundColor = .appBg
        return view
    }
    
    static func buttonBlockingView() -> UIView {
        let view = UIView()
        view.backgroundColor = .appActiveSelect
        return view
    }
    
}
