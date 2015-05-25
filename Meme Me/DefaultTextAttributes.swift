//
//  DefaultTextAttributes.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit


struct DefaultTextAttributes {
    
    // Set the default text attributes dictionary.
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        // Specify positive values to change the stroke width alone. Specify negative values to stroke and fill the text.
        NSStrokeWidthAttributeName: -3.0
    ]
}