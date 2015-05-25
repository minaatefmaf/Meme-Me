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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool) {
        // Disable the camera button if the device doesn't have a camera (e.g. the simulator)
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraButton.enabled = false
        }
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

}
