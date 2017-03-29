//
//  Meme+CoreDataProperties.swift
//  Meme Me
//
//  Created by Mina Atef on 3/29/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Foundation
import CoreData


extension Meme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meme> {
        return NSFetchRequest<Meme>(entityName: "Meme");
    }

    @NSManaged public var bottomText: String?
    @NSManaged public var topText: String?
    @NSManaged public var memedImageName: String?
    @NSManaged public var originalImageName: String?

}
