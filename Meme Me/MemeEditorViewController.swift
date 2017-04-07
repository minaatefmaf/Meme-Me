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
    
    private var tapRecognizer: UITapGestureRecognizer? = nil
    
    // Add references to the delegates
    let memeTopTextFieldDelegate = MemeTextFieldDelegate()
    let memeBottomTextFieldDelegate = MemeTextFieldDelegate()
    
    // Set the default text attributes dictionary.
    let memeTextAttributes = DefaultTextAttributes().memeTextAttributes
    
    // Set the core data stack variable
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var coreDataStack: CoreDataStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the core data stack
        coreDataStack = delegate.coreDataStack
        
        // Assign our defult text attributes to the textfields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Set the textfields' initial text
        topTextField.text = "TOP TEXT"
        bottomTextField.text = "BOTTOM TEXT"
        
        // Align the text in the textfields to center.
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        
        // Disable the share button initially.
        shareButton.isEnabled = false
        
        // Assign each textfield to its proper delegate
        topTextField.delegate = memeTopTextFieldDelegate
        bottomTextField.delegate = memeBottomTextFieldDelegate
        
        // Initialize and configure the tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable the camera button if the device doesn't have a camera (e.g. the simulator)
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            cameraButton.isEnabled = false
        }
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
        // Add the tap recognizer
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
        
        // Remove the tap recognizer
        removeKeyboardDismissRecognizer()
    }
    
    
    override var prefersStatusBarHidden : Bool {
        // Hide the status bar
        return true
    }
    
    @IBAction func shareMemedImage(_ sender: UIBarButtonItem) {
        // Generate a memed image
        let memedImage = generateMemedImage()
        // Define an instance of the ActivityViewController
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // Present the ActivityViewController
        self.present(activityController, animated: true, completion: nil)
        
        // Save the meme & dismiss the ActivityViewController once it has done its work.
        activityController.completionWithItemsHandler  = {
            activityType, completed, returnedItems, activityError in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelMemeEditor(_ sender: UIBarButtonItem) {
        // Navigate to the tab bar (SentMemes)
        navigateToTheTabBarController()
    }
    
    // Navigate to the tab bar (SentMemes) when needed
    func navigateToTheTabBarController() {
        var controller: UITabBarController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        pickAnImage(UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        pickAnImage(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    // A general function to pick an image from a given source.
    // Its soul purpose is to serve the (IBAction pickAnImageFromCamera) & (IBAction pickAnImageFromAlbum) functions.
    func pickAnImage(_ sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }
    
    // Set the chosen image to our imagePickerView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            // Enable the share button when an image has been chosen.
            shareButton.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // Accommodate for the keyboard when the user try to enter text in the bottom textfield.
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // Accommodate for the keyboard when the user finish editing the text in the bottom textfield.
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // Get the keyboard height.
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // Of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        // Get a notification when the keyboard show or hide.
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // Unsubscribe from the notifications we subscribed earlier.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Keyboard Fixes
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true) // this will cause the view (or any of its embedded text fields to resign the first                   responder status
    }
    
    func save() {
        // Create the meme dictionary
        let dictionary: [String : String] = [
            Meme.Keys.TopText: topTextField.text!,
            Meme.Keys.BottomText: bottomTextField.text!
        ]
        
        // Create the meme
        let meme = Meme(dictionary: dictionary, context: coreDataStack.context)
        
        // Save the images to the disc
        let image = ImageData(context: coreDataStack.context)
        image.originalImage = imagePickerView.image
        let memedImage = generateMemedImage()
        image.memedImage = memedImage
        
        meme.image = image
        meme.thumbnailImage = prepareTheThumbnailImage(image: memedImage)
        
        // Persisit the meme to the disc
        do {
            try coreDataStack.saveContext()
        } catch {
            print("Error while saving.")
        }
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide navigationBar and toolBar
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navigationBar and toolBar
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: - Creating The Thumbnail Image Helper functions
    
    func prepareTheThumbnailImage(image: UIImage) -> UIImage {
        
        // Crop the image:
        let croppedImage = cropToSquareImage(image: image)
        
        // Resize the image:
        let resizedImage = resizeImage(image: croppedImage, scaleX: 0.1, scaleY: 0.1)
        
        return resizedImage
        
    }
    
    func cropToSquareImage(image: UIImage) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        
        var squareStartingPointX: CGFloat = 0.0
        var squareStartingPointY: CGFloat = 0.0
        // Set the square side length to the smaller side of the given rectangle "image"
        let sideLength = (contextSize.width < contextSize.height) ? contextSize.width : contextSize.height
        
        // See what size is longer and create the center off of that
        if contextSize.width < contextSize.height {
            squareStartingPointY = (contextSize.height - contextSize.width) / 2
        } else {
            squareStartingPointX = (contextSize.width - contextSize.height) / 2
        }
        
        // Create the square
        let rect: CGRect = CGRect(x: squareStartingPointX, y: squareStartingPointY, width: sideLength, height: sideLength)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
        
    }
    
    func resizeImage(image: UIImage, scaleX: CGFloat, scaleY: CGFloat) -> UIImage {
        
        let size = image.size.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        let hasAlpha = false
        // Automatically use scale factor of main screen
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
        
    }
    
}

