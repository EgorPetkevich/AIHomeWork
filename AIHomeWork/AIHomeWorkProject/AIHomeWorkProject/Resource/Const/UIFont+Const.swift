//
//  UIFont+Const.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension UIFont {
    
    static func regularFont(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .regular, width: .expanded)
    }
    
    static func boldFont(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .bold, width: .expanded)
    }
    
    static func semiBold(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .semibold, width: .expanded)
    }
    
    func with(weight: CGFloat, size: CGFloat) -> UIFont {
      let newDescriptor = fontDescriptor.addingAttributes([.traits: [
        UIFontDescriptor.TraitKey.weight: UIFont.Weight(weight)]
      ])
      return UIFont(descriptor: newDescriptor, size: pointSize)
    }
    
}
