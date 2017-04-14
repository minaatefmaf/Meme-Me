//
//  ImageData+CoreDataClass.swift
//  Meme Me
//
//  Created by Mina Atef on 4/7/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import UIKit
import CoreData

@objc(ImageData)
public class ImageData: NSManagedObject {

    struct Keys {
        static let EntityName = "ImageData"
    }
    
    /* Auto convertion from UIImage to NSData for the images */
    var originalImage: UIImage! {
        didSet { originalImageData = UIImageJPEGRepresentation(originalImage, 1.0) as NSData? }
    }
    var memedImage: UIImage! {
        didSet { memedImageData = UIImageJPEGRepresentation(memedImage, 1.0) as NSData? }
    }
    
    
    // Initialize the class
    convenience init(context: NSManagedObjectContext) {
        
        // Get the entity associated with the class type
        if let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context) {
            self.init(entity: entity, insertInto: context)
            
        } else {
            // Crash if the entity name isn't there
            fatalError("Unable to find Entity Name!")
        }
        
    }
    
    
    /* Auto convertion from NSData to UIImage for the images */
    func getOriginalImage() -> UIImage? {
        if let originalImageData = originalImageData {
            return UIImage(data: originalImageData as Data)
        }
        return nil
    }
    func getMemedImage() -> UIImage? {
        if let memedImageData = memedImageData {
            return UIImage(data: memedImageData as Data)
        }
        return nil
    }
    
}
