//
//  UIImageExtensions.swift
//  MovieApp
//
//  Created by Nalan Duman on 13.12.2024.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }

    func resizedImage(minimumDimension: CGFloat = 600) -> UIImage? {
        let aspectRatio = self.size.width / self.size.height
        var newWidth: CGFloat
        var newHeight: CGFloat
        
        if self.size.width > self.size.height {
            newWidth = minimumDimension
            newHeight = minimumDimension / aspectRatio
        } else {
            newHeight = minimumDimension
            newWidth = minimumDimension * aspectRatio
        }
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func toBase64() -> String? {
        guard let resizedImage = resizedImage(),
              let imageData = resizedImage.pngData() else { return nil }
        return imageData.base64EncodedString()
    }
}
