//
//  Meme+CoreDataClass.swift
//  Meme Me
//
//  Created by Mina Atef on 3/28/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import UIKit
import CoreData

@objc(Meme)
public class Meme: NSManagedObject {
    
    struct Keys {
        static let EntityName = "Meme"
        static let TopText = "topText"
        static let BottomText = "bottomText"
    }
    
    // Initialize the class from a dictionary
    convenience init(dictionary: [String: String], context: NSManagedObjectContext) {
        
        // Get the entity associated with the class type
        if let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context) {
            self.init(entity: entity, insertInto: context)
            
            // Initialize the properties
            self.topText = dictionary[Keys.TopText]
            self.bottomText = dictionary[Keys.BottomText]
            self.createdAt = Date() as NSDate?
            
        } else {
            // Crash if the entity name isn't there
            fatalError("Unable to find Entity Name!")
        }
        
    }
    
}
