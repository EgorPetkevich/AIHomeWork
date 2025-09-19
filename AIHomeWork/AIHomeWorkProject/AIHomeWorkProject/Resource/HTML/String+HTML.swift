//
//  String+HTML.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 23.08.24.
//

import UIKit

extension String {
    
    static func parse(html: String,
                      font: UIFont,
                      fontWeight: CGFloat
    ) -> String? {
        
        let fontFamilyName = font.familyName
        let fontSize = font.pointSize

        let htmlTemplate = """
        <span style="font-family: '-apple-system', '\(fontFamilyName)'; font-size: \(fontSize)px; font-weight: \(fontWeight);">
        \(html)
        </span>
        """

        if let data = htmlTemplate.data(using: .utf8) {
            if let attributedString = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                            documentAttributes: nil) {
                return attributedString.string
            }
        }
        return nil
    }

}
