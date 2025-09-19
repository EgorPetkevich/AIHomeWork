//
//  UIButton+Style.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.08.24.
//

import UIKit

extension UIButton {
    
    static func clearButton(_ text: String? = nil,
                            tintColor: UIColor? = nil,
                            borderWidth: CGFloat? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        if let text, let tintColor {
            button.setTitle(text, for: .normal)
            button.setTitleColor(tintColor, for: .normal)
            button.titleLabel?.font = .regularFont(size: 15.0)
        }
        if let borderWidth, let tintColor {
            button.setBorder(width: borderWidth, color: tintColor)
        }
        return button
    }
    
    static func underActionButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.appGrey, for: .normal)
        button.titleLabel?.font = .regularFont(size: 14.0)
        button.backgroundColor = .clear
        return button
    }
    
    static func actionButton(title: String, image: UIImage? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .regularFont(size: 13)
        button.setTitleColor(.appWhite, for: .normal)
        button.backgroundColor = .appActive
        if let image {
            button.setImage(image, for: .normal)
            button.tintColor = .appWhite
        }
        return button
    }
    
    static func crossButton() -> UIButton {
        let button = UIButton()
        button.setImage(.Paywall.crossImage, for: .normal)
        return button
    }
    
    static func scanButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .appActive
        button.setImage(.MainApp.TabBar.scanImage, for: .normal)
        return button
    }
    
    static func settingButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .appActive
        button.setImage(.MainApp.Home.settingImage, for: .normal)
        return button
    }
    
    static func backArrowButton() -> UIButton {
        let button = UIButton()
        button.setImage(.AppIcon.leftArrowImage, for: .normal)
        return button
    }
    
    static func cropButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        
        configuration.image = .AppIcon.cropImage
        configuration.title = "Crop"
        configuration.baseBackgroundColor = .clear
        configuration.imagePadding = 3
        configuration.imagePlacement = .top
        configuration.titleAlignment = .center
        configuration.baseForegroundColor = .appBlack
        configuration.attributedTitle?.font = .regularFont(size: 10)
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }
    
    static func editButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(.AppIcon.menuDotsImage, for: .normal)
        button.tintColor = .appBlack
        return button
    }
   
}

