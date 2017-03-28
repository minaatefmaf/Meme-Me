//
//  Image+CoreDataProperties.swift
//  Meme Me
//
//  Created by Mina Atef on 3/28/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var originalImagePath: String?
    @NSManaged public var memedImagePath: String?
    @NSManaged public var meme: Meme?

}
