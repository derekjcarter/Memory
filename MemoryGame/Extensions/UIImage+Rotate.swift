//
//  UIImage+Rotate.swift
//  MemoryGame
//
//  Created by Derek Carter on 1/3/19.
//  Copyright © 2019 Daniel Tsirulnikov. All rights reserved.
//

import UIKit

extension UIImage {
    
    func rotate(radians: CGFloat) -> UIImage? {
        //https://stackoverflow.com/questions/27092354/rotating-uiimage-in-swift/29753437
        
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        var newSize = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        draw(in: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
