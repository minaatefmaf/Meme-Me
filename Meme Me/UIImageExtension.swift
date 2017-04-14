//
//  UIImageExtension.swift
//  Meme Me
//
//  Created by Mina Atef on 4/14/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import UIKit

extension UIImage {
    
    // To help with the rotated image issue
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return normalizedImage;
    }
    
}
