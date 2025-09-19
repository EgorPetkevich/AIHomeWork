//
//  UILabel+Style.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.08.24.
//

import UIKit

extension UILabel {
    
    static func titleLabel(_ text: String, size: CGFloat = 28) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: .bold, width: .expanded)
        label.textColor = .appBlack
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }
    
    static func homeTitleLabel(_ text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: .bold, width: .expanded)
        label.textColor = .appBlack
        label.numberOfLines = .zero
        label.textAlignment = .left
        return label
    }
    
    static func semiBoldTitleLabel(_ text: String, size: CGFloat = 28) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 28, weight: .semibold, width: .expanded)
        label.textColor = .appBlack
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }
    
    static func subTitleLabel(_ text: String, 
                              size: CGFloat,
                              textColor: UIColor = .appGrey) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: .regular, width: .expanded)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = textColor
        return label
    }
    
    static func prodSubTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .regular, width: .expanded)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .OnboardingProd.subTitleColor
        return label
    }
    
    static func revSubTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .regular, width: .expanded)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = .appBlack
        return label
    }
    
}
