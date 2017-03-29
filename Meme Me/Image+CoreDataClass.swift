//
//  Image+CoreDataClass.swift
//  Meme Me
//
//  Created by Mina Atef on 3/28/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject {
    
    struct Keys {
        static let EntityName = "Image"
        static let MemedImagePath = "memedImageName"
        static let OriginalImagePath = "originalImageName"
    }
    
    // Initialize the class from a dictionary
    convenience init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        // Get the entity associated with the class type
        if let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context) {
            self.init(entity: entity, insertInto: context)
            
            // Initialize the properties
            self.originalImageName = dictionary[Keys.OriginalImagePath] as! String!
            self.memedImageName = dictionary[Keys.MemedImagePath] as! String!
        } else {
            // Crash if the entity name isn't there
            fatalError("Unable to find Entity NameQ")
        }
        
    }

}
