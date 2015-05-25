//
//  MemeEditorViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/20/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Add references to the delegates
    let memeTopTextFieldDelegate = MemeTopTextFieldDelegate()
    let memeBottomTextFieldDelegate = MemeBottomTextFieldDelegate()
    
    // Set the default text attributes dictionary.
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign our defult text attributes to the textfields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Set the textfields' initial text
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        // Align the text in the textfields to center.
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        // Assign each textfield to its proper delegate
        topTextField.delegate = memeTopTextFieldDelegate
        bottomTextField.delegate = memeBottomTextFieldDelegate
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable the camera button if the device doesn't have a camera (e.g. the simulator)
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraButton.enabled = false
        }
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        // Unsubscribe to keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }


    override func prefersStatusBarHidden() -> Bool {
        // Hide the status bar
        return true
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickAnImage(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    // A general function to pick an image from a given source.
    // Its soul purpose is to surve for the (IBAction pickAnImageFromCamera) & (IBAction pickAnImageFromAlbum) functions.
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // Set the chosen image to our imagePickerView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Accommodate for the keyboard when the user try to enter text in the bottom textfield.
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Accommodate for the keyboard when the user finish editing the text in the bottom textfield.
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // Get the keyboard height.
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // Of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        // Get a notification when the keyboard show or hide.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // Unsubscribe from the notifications we subscribed earlier.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }


}

