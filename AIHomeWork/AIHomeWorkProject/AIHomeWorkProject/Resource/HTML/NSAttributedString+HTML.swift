//
//  NSAttributedString+HTML.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension NSAttributedString {
    
    static func parse(html: String,
                      font: UIFont,
                      fontWeight: CGFloat
    ) -> NSAttributedString? {
        
        let fontFamilyName = font.familyName
        let fontSize = font.pointSize
        if
            let data = "<span style=\"font-family: '-apple-system', '\(fontFamilyName)'; font-size: \(fontSize)px; font-weight: \(fontWeight)\">\(html)</span>"
                .data(using: .utf8) {
            return try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
        }
        return nil
    }
    
}
