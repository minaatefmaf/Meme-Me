//
//  MemeBottomTextFieldDelegate.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemeBottomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // Should clear the initial value "Bottom" when a user clicks the textfield for the first time.
    var firstEdit = true
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // Should clear the initial value "Bottom" when a user clicks the textfield for the first time.
        if firstEdit {
            textField.text = ""
        }
        // The user can continue editing the text he entered so far!
        firstEdit = false
        
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