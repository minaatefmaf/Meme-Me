//
//  MemeTopTextFieldDelegate.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemeTopTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // Should clear the initial value "TOP" when a user clicks the textfield for the first time.
    var firstEdit = true
    
    // Set the default text attributes dictionary.
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0
    ]
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // Should clear the initial value "TOP" when a user clicks the textfield for the first time.
        if firstEdit {
            textField.text = ""
            
            // The user can continue editing the text he entered so far!
            firstEdit = false
        }
        
        // Maintain the same defaults for a new editing (if nothing is entered at the first edit)
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}