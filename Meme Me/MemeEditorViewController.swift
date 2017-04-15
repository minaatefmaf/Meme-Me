//
//  MemeEditorViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/20/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import Photos

protocol MemeEditorViewControllerDelegate {
    func editTheMeme(MemeEditor: MemeEditorViewController, didEditMeme memeIsEdited: Bool, newMeme: Meme?)
}

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private weak var imagePickerView: UIImageView!
    @IBOutlet private weak var cameraButton: UIBarButtonItem!
    @IBOutlet private weak var topTextField: UITextField!
    @IBOutlet private weak var bottomTextField: UITextField!
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var toolBar: UIToolbar!
    
    private var tapRecognizer: UITapGestureRecognizer? = nil
    
    // Add references to the delegates
    private let memeTopTextFieldDelegate = MemeTextFieldDelegate()
    private let memeBottomTextFieldDelegate = MemeTextFieldDelegate()
    
    // Set the default text attributes dictionary.
    private let memeTextAttributes = DefaultTextAttributes().memeTextAttributes
    
    // Set the core data stack variable
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var coreDataStack: CoreDataStack!
    
    // To hold the mode of the view (whether the statusbar and the toolbars are visible or not)
    private enum ViewMode {
        case visibleViews
        case hiddenViews
    }
    
    // Initialize the viewState to all views visible
    private var viewState = ViewMode.visibleViews
    
    // For holding the new meme
    private var newMeme: Meme!
    
    // For holding the old meme if the scene is initiated to edit an old meme
    var oldMeme: Meme?
    
    // A placeholder for the delegate
    var memeEditorDelegate: MemeEditorViewControllerDelegate?
    
    // To hold the state of the scene (either creating a new meme, or modifying an old one)
    enum EditorMode {
        case createNewMeme
        case modifyOldMeme
    }
    
    // Initialize the sceneMode to meme creation mode
    var sceneMode: EditorMode = .createNewMeme
    
    override var prefersStatusBarHidden: Bool {
        // Hide the status bar
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the core data stack
        coreDataStack = appDelegate.coreDataStack
        
        // Configure the UI
        configureUIForViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure the UI
        configureUIForViewWillAppear()
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        
        // Add the tap recognizer
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to keyboard notifications
        unsubscribeFromKeyboardNotifications()
        
        // Remove the tap recognizer
        removeKeyboardDismissRecognizer()
    }
    
    @IBAction private func saveMemedImage(_ sender: UIBarButtonItem) {
        
        // If the editor is in the the "modifying an old meme" mode, check if the user want to keep the old meme or delete it
        if sceneMode == .modifyOldMeme {
            // Prepare an alert to confirm the meme deletion
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            // The Save meme action
            let saveNewAction = UIAlertAction(title: Alerts.SaveMeme, style: .default) { [weak weakSelf = self] _ in
                // Create and sava a new meme
                weakSelf?.createAndSaveNewMeme()
                
                // Let the other controller know that the meme has been edited, and pass the new meme
                weakSelf?.memeEditorDelegate!.editTheMeme(MemeEditor: self, didEditMeme: true, newMeme: weakSelf?.newMeme)
                
                // Navigate back to the meme viewer
                weakSelf?.dismiss(animated: true, completion: nil)
            }
            
            // The Save meme & Delete old meme action
            let saveNewAndDeleteOldAction = UIAlertAction(title: Alerts.SaveAndDeleteOldMeme, style: .destructive) { [weak weakSelf = self] _ in
                // Create and sava a new meme
                weakSelf?.createAndSaveNewMeme()
                
                // Delete the old meme
                weakSelf?.coreDataStack.context.delete((weakSelf?.oldMeme)!)
                
                // Persist the context to the disk
                weakSelf?.coreDataStack.save()
                
                // Let the other controller know that the meme has been edited, and pass the new meme
                weakSelf?.memeEditorDelegate!.editTheMeme(MemeEditor: self, didEditMeme: true, newMeme: weakSelf?.newMeme)
                
                // Navigate back to the meme viewer
                weakSelf?.dismiss(animated: true, completion: nil)
            }
            
            // The cancel action
            let cancelAction = UIAlertAction(title: Alerts.Cancel, style: .cancel) { [weak weakSelf = self] _ in
                // Make sure the cancel button is enabled (for the iPad case)
                weakSelf?.cancelBarButton.isEnabled = true
            }
            
            // Add the actions
            alert.addAction(saveNewAction)
            alert.addAction(saveNewAndDeleteOldAction)
            alert.addAction(cancelAction)
            
            // For iPads, telling them where to attach the popover (the action sheet replaceable there)
            alert.popoverPresentationController?.barButtonItem = saveBarButton
            
            // Make sure the cancel button is disabled (for the iPad case)
            cancelBarButton.isEnabled = false
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        
        } else { // The meme creation mode
            // Save the new meme
            createAndSaveNewMeme()
            
            // Navigate back to the table/collection view
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    @IBAction private func cancelMemeEditor(_ sender: UIBarButtonItem) {
        // Navigate back to the table/collection view
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        // Make sure the app has the permission to open the camera
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        guard status == .authorized else {
            showAlertAndRedirectToSettings(alertTitle: Alerts.CameraDisabledTitle, alertMessage: Alerts.CameraDisabledMessage)
            return
        }
        
        pickAnImage(UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction private func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        // Make sure the app has the permission to access the photo library
        let status = PHPhotoLibrary.authorizationStatus()
        guard status == .authorized else {
            showAlertAndRedirectToSettings(alertTitle: Alerts.PhotosDisabledTitle, alertMessage: Alerts.PhotosDisabledMessage)
            return
        }
        
        pickAnImage(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    // A general function to pick an image from a given source.
    // Its soul purpose is to serve the (IBAction pickAnImageFromCamera) & (IBAction pickAnImageFromAlbum) functions.
    private func pickAnImage(_ sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }
    
    // Set the chosen image to our imagePickerView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            // Enable the save button when an image has been chosen.
            saveBarButton.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Keyboard Fixes
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        // Accommodate for the keyboard when the user try to enter text in the bottom textfield.
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Accommodate for the keyboard when the user finish editing the text in the bottom textfield.
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // Get the keyboard height.
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // Of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    private func subscribeToKeyboardNotifications() {
        // Get a notification when the keyboard show or hide.
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        // Unsubscribe from the notifications we subscribed earlier.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    private func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    @objc private func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        
        if topTextField.isFirstResponder || bottomTextField.isFirstResponder {
            view.endEditing(true) // this will cause the view (or any of its embedded text fields to resign the first responder status
        } else {
            // Toggle the navigation bar and the buttom toolbar
            if viewState == .visibleViews {
                viewState = .hiddenViews
                navigationBar.isHidden = true
                toolBar.isHidden = true
            } else {
                viewState = .visibleViews
                navigationBar.isHidden = false
                toolBar.isHidden = false
            }
            
            // Toggle the view's background color
            if view.backgroundColor == .white {
                view.backgroundColor = .black
            } else {
                view.backgroundColor = .white
            }
        }
        
        
    }
    
    
    // MARK: - Creating The Thumbnail Image Helper functions
    
    private func prepareTheThumbnailImage(image: UIImage) -> UIImage {
        
        // Crop the image:
        let croppedImage = cropToSquareImage(image: image)
        
        // Resize the image:
        let resizedImage = resizeImage(image: croppedImage, scaleX: 0.2, scaleY: 0.2)
        
        return resizedImage
        
    }
    
    private func cropToSquareImage(image: UIImage) -> UIImage {
        
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
    
    private func resizeImage(image: UIImage, scaleX: CGFloat, scaleY: CGFloat) -> UIImage {
        
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
    
    // MARK: - General Helper Methods
    
    private func createAndSaveNewMeme() {
        // Create the meme dictionary
        let dictionary: [String : String] = [
            Meme.Keys.TopText: topTextField.text!,
            Meme.Keys.BottomText: bottomTextField.text!
        ]
        
        // Create the meme
        newMeme = Meme(dictionary: dictionary, context: coreDataStack.context)
        
        // Save the images to the disc
        let image = ImageData(context: coreDataStack.context)
        
        // Make sure the image is saved with the correct orientaion (when captured by the camera)
        image.originalImage = imagePickerView.image?.correctlyOrientedImage()
        let memedImage = generateMemedImage()
        image.memedImage = memedImage
        
        newMeme.image = image
        newMeme.thumbnailImage = prepareTheThumbnailImage(image: memedImage)
        
        // Persisit the meme to the disc
        coreDataStack.save()
    }
    
    private func generateMemedImage() -> UIImage {
        
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

    private func showAlertAndRedirectToSettings(alertTitle title: String, alertMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: Alerts.GoToSettings, style: .default) { action in
            // Redirect the user to the app's settings in the general seeting app
            UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        }
        let cancelAction = UIAlertAction(title: Alerts.AskLater, style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - ConfigureUI Helper Methods
    
    private func configureUIForViewDidLoad() {
        // Assign our defult text attributes to the textfields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Set the textfields' initial text
        topTextField.text = "TOP TEXT"
        bottomTextField.text = "BOTTOM TEXT"
        
        // Align the text in the textfields to center.
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
        
        // Disable the save button initially.
        saveBarButton.isEnabled = false
        
        // Assign each textfield to its proper delegate
        topTextField.delegate = memeTopTextFieldDelegate
        bottomTextField.delegate = memeBottomTextFieldDelegate
        
        // Initialize the meme data if the scene is initiated to edit an old meme
        if let oldMeme = self.oldMeme {
            imagePickerView.image = oldMeme.image!.getOriginalImage()
            topTextField.text = oldMeme.topText
            bottomTextField.text = oldMeme.bottomText
            
            // Enable the save button
            saveBarButton.isEnabled = true
        }
        
        // Initialize and configure the tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    private func configureUIForViewWillAppear() {
        // Disable the camera button if the device doesn't have a camera (e.g. the simulator)
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            cameraButton.isEnabled = false
        }
    }
    
}

