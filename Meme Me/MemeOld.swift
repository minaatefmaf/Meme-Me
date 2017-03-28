//
//  MemeOld.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import Foundation
import UIKit

struct MemeOld {
    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage: UIImage
    
    // Construct a Meme
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }

}
