//
//  UIImage+Crop.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 9.09.24.
//

import UIKit

extension UIImage {
    
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    static func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage? {
        guard let cgImage = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    static func cropImageUnderFrame(photoImageView: UIImageView, transparentRect: CGRect) -> UIImage? {
        guard let image = photoImageView.image else { return nil }
        
        let orientedImage = image.fixedOrientation()
        
        let imageSize = orientedImage.size
        let imageViewSize = photoImageView.bounds.size
        
        let imageAspectRatio = imageSize.width / imageSize.height
        let imageViewAspectRatio = imageViewSize.width / imageViewSize.height
        
        var scaledRect = CGRect.zero
        
        if imageAspectRatio > imageViewAspectRatio {
            let scaledHeight = imageViewSize.width / imageAspectRatio
            let yOffset = (imageViewSize.height - scaledHeight) / 2.0
            scaledRect.origin.x = transparentRect.origin.x * (imageSize.width / imageViewSize.width)
            scaledRect.origin.y = (transparentRect.origin.y - yOffset) * (imageSize.height / scaledHeight)
            scaledRect.size.width = transparentRect.size.width * (imageSize.width / imageViewSize.width)
            scaledRect.size.height = transparentRect.size.height * (imageSize.height / scaledHeight)
        } else {
            let scaledWidth = imageViewSize.height * imageAspectRatio
            let xOffset = (imageViewSize.width - scaledWidth) / 2.0
            scaledRect.origin.x = (transparentRect.origin.x - xOffset) * (imageSize.width / scaledWidth)
            scaledRect.origin.y = transparentRect.origin.y * (imageSize.height / imageViewSize.height)
            scaledRect.size.width = transparentRect.size.width * (imageSize.width / scaledWidth)
            scaledRect.size.height = transparentRect.size.height * (imageSize.height / imageViewSize.height)
        }
        
        scaledRect = scaledRect.intersection(CGRect(origin: .zero, size: imageSize))
        
        return cropImage(image: orientedImage, toRect: scaledRect)
    }
    
}
