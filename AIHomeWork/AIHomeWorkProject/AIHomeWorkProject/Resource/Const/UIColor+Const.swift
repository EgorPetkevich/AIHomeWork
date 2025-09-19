//
//  UIColor+Const.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIColor {
    
    convenience init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    // MARK: - App Colors
    static let appBg: UIColor = .init(247, 247, 255, 1)
    static let appActive: UIColor = .init(64, 53, 255, 1)
    static let appActiveDisable: UIColor = .init(64, 53, 255, 0.4)
    static let appBlack: UIColor = .init(7, 7, 7, 1)
    static let appWhite: UIColor = .init(255, 255, 255, 1)
    static let appGrey: UIColor = .init(139, 139, 139, 1)
    static let appLightGrey: UIColor = .init(7, 7, 7, 0.4)
    static let appBgGray: UIColor = .init(7, 7, 7, 0.1)
    static let appDarkGray: UIColor = .init(237, 237, 250, 1)
    static let appRed: UIColor = .init(255, 85, 51, 1)
    static let appLightBlue: UIColor = .init(199, 215, 255, 1)
    static let appMessageBlack: UIColor = .init(7, 7, 7, 0.7)
    static var appShadow: UIColor = .init(0, 0, 0, 0.5)
    static let appActiveLight : UIColor = .init(64, 53, 255, 0.2)
    static let appActiveSelect: UIColor = .init(255, 255, 255, 0.5)
    
    // MARK: - OnboardingProd Colors
    enum OnboardingProd {
        static let subTitleColor: UIColor = .init(7, 7, 7, 0.5)
    }
    
    // MARK: - ActivityIndicator Colors
    enum ActivityIndicator {
        static let currentDotColor: UIColor = .init(64, 53, 255, 1)
        static let dotColor: UIColor = .init(64, 53, 255, 0.9)
        static let pastDotColor: UIColor = .init(64, 53, 255, 0.7)
    }
    
    // MARK: - PaywallTrialSwitch Colors
    enum PaywallTrialSwitch {
        static let tintColor: UIColor = .init(139, 139, 139, 1)
        static let OnTintColor: UIColor = .init(185, 255, 145, 1)
    }
    
    enum TabBar {
        static let unselectedItemColor: UIColor = .init(181, 181, 181, 1)
    }
    
}
