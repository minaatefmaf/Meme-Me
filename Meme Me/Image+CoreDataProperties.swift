//
//  Image+CoreDataProperties.swift
//  Meme Me
//
//  Created by Mina Atef on 3/29/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var memedImageName: String?
    @NSManaged public var originalImageName: String?
    @NSManaged public var meme: Meme?

}
