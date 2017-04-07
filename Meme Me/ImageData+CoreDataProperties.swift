//
//  ImageData+CoreDataProperties.swift
//  Meme Me
//
//  Created by Mina Atef on 4/7/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData");
    }

    @NSManaged public var originalImageData: NSData?
    @NSManaged public var memedImageData: NSData?
    @NSManaged public var thumbnailImageData: NSData?
    @NSManaged public var meme: Meme?

}
