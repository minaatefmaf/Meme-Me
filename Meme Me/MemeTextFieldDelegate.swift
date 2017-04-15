//
//  MemeTextFieldDelegate.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // Set the default text attributes dictionary.
    private let memeTextAttributes = DefaultTextAttributes().memeTextAttributes
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // Should clear the initial value when a user clicks the textfield for the first time.
        if textField.text == "TOP TEXT" || textField.text == "BOTTOM TEXT" {
            textField.text = ""
        }
        
        // Maintain the same defaults for a new editing (if nothing is entered at the first edit)
        if textField.text!.isEmpty {
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = NSTextAlignment.center
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
