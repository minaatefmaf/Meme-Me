//
//  Meme+CoreDataProperties.swift
//  Meme Me
//
//  Created by Mina Atef on 4/7/17.
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
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var thumbnailImageData: NSData?
    @NSManaged public var image: ImageData?

}
