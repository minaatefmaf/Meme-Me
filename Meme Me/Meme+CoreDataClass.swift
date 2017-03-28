//
//  Meme+CoreDataClass.swift
//  Meme Me
//
//  Created by Mina Atef on 3/28/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Foundation
import CoreData

@objc(Meme)
public class Meme: NSManagedObject {
    
    struct Keys {
        static let EntityName = "Meme"
        static let TopText = "topText"
        static let BottomText = "bottomText"
    }
    
    // The standard Core Data init method.
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // Initialize the class from a dictionary
    convenience init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        // Get the entity associated with the class type
        if let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context) {
            self.init(entity: entity, insertInto: context)
            
            // Initialize the properties
            self.topText = dictionary[Keys.TopText] as? String
            self.bottomText = dictionary[Keys.BottomText] as? String
        } else {
            // Crash if the entity name isn't there
            fatalError("Unable to find Entity NameQ")
        }
        
    }


}
