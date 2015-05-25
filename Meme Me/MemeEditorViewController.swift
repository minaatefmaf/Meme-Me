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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // Add references to the delegates
    let memeTopTextFieldDelegate = MemeTopTextFieldDelegate()
    let memeBottomTextFieldDelegate = MemeBottomTextFieldDelegate()
    
    // Set the default text attributes dictionary.
    let memeTextAttributes = DefaultTextAttributes().memeTextAttributes
    
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
        
        // Disable the share button initially.
        shareButton.enabled = false
        
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
    
    @IBAction func shareMemedImage(sender: UIBarButtonItem) {
        // Generate a memed image
        let memedImage = generateMemedImage()
        // Define an instance of the ActivityViewController
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // Present the ActivityViewController
        self.presentViewController(activityController, animated: true, completion: nil)
        
        // Save the meme & dismiss the ActivityViewController once it has done its work.
        activityController.completionWithItemsHandler  = {
            activityType, completed, returnedItems, activityError in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelMemeEditor(sender: UIBarButtonItem) {
        navigateToTheTabBarController()
    }
    
    func navigateToTheTabBarController() {
        var controller: UITabBarController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController
        
        self.presentViewController(controller, animated: true, completion: nil)
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
            // Enable the share button when an image has been chosen.
            shareButton.enabled = true
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

    func save() {
        // Create the meme
        var meme = Meme(topText: topTextField.text!,
                        bottomText: bottomTextField.text!,
                        image: imagePickerView.image!,
                        memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide navigationBar and toolBar
        navigationBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show navigationBar and toolBar
        navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }

}

