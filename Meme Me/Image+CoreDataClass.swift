//
//  Image+CoreDataClass.swift
//  Meme Me
//
//  Created by Mina Atef on 3/28/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Image)
public class Image: NSManagedObject {
    
    struct Keys {
        static let EntityName = "Image"
        static let MemedImageName = "memedImageName"
        static let OriginalImageName = "originalImageName"
    }
    
    // Shared Image Cache
    private let imageCache = ImageCache()
    
    // Get the original image
    var originalImage: UIImage? {
        get {
            return imageCache.imageWithIdentifier(originalImageName)
        }
        
        set {
            imageCache.storeImage(newValue, withIdentifier: originalImageName!)
        }
    }
    
    // Get the memed image
    var memedImage: UIImage? {
        get {
            return imageCache.imageWithIdentifier(memedImageName)
        }
        
        set {
            imageCache.storeImage(newValue, withIdentifier: memedImageName!)
        }
    }
    
    // Initialize the class from a dictionary
    convenience init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        // Get the entity associated with the class type
        if let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context) {
            self.init(entity: entity, insertInto: context)
            
            // Initialize the properties
            self.originalImageName = dictionary[Keys.OriginalImageName] as! String!
            self.memedImageName = dictionary[Keys.MemedImageName] as! String!
        } else {
            // Crash if the entity name isn't there
            fatalError("Unable to find Entity NameQ")
        }
        
    }
    
    public override func prepareForDeletion() {
        imageCache.deleteImage(withIdentifier: originalImageName!)
        imageCache.deleteImage(withIdentifier: memedImageName!)
    }

}
