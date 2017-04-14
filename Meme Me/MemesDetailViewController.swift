//
//  MemesDetailViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/26/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemesDetailViewController: UIViewController, MemeEditorViewControllerDelegate {
    
    @IBOutlet weak var buttomToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    // The right bar button
    private var addNewMemeButton: UIBarButtonItem!
    
    private var tapRecognizer: UITapGestureRecognizer? = nil
    
    // Use to show/hide the status bar
    var statusBarIsHidden = false
    
    // Set the core data stack variable
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var coreDataStack: CoreDataStack!
    
    override var prefersStatusBarHidden: Bool {
        // Show/Hide the status bar
        return statusBarIsHidden
    }
    
    // To hold the mode of the view (whether the statusbar and the toolbars are visible or not)
    private enum ViewMode {
        case visibleViews
        case hiddenViews
    }
    
    // Initialize the viewState to all views visible
    private var viewState = ViewMode.visibleViews
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.image = meme.image?.getMemedImage()
        
        // Add the tap recognizer
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the core data stack
        coreDataStack = delegate.coreDataStack
        
        // Add the right bar button
        addNewMemeButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MemesDetailViewController.navigateToMemeEditorView))
        self.navigationItem.setRightBarButtonItems([addNewMemeButton], animated: false)
        
        // Add the image
        self.imageView!.image = meme.image?.getMemedImage()
        
        // Configure the UI
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the tap recognizer
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    @IBAction func shareMemedImage(_ sender: UIBarButtonItem) {
        // Define an instance of the ActivityViewController
        let activityController = UIActivityViewController(activityItems: [self.imageView!.image as Any], applicationActivities: nil)
        // Present the ActivityViewController
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonIsPressed(_ sender: Any) {
        // Prepare an alert to confirm the meme deletion
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Meme", style: UIAlertActionStyle.destructive) { [weak weakSelf = self] _ in
            // Delete the meme
            weakSelf?.deleteTheMeme()
        }
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Tab Recognizer Methods
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        // Toggle the status bar
        statusBarIsHidden = !statusBarIsHidden
        setNeedsStatusBarAppearanceUpdate()
        
        // Toggle the navigation bar and the buttom toolbar
        if viewState == .visibleViews {
            viewState = .hiddenViews
            navigationController?.navigationBar.isHidden = true
            buttomToolbar.isHidden = true
        } else {
            viewState = .visibleViews
            navigationController?.navigationBar.isHidden = false
            buttomToolbar.isHidden = false
        }
        
        // Toggle the view's background color
        if view.backgroundColor == .white {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
    
    
    // MARK: - MemeEditorViewControllerDelegate Methods
    
    func editTheMeme(MemeEditor: MemeEditorViewController, didEditMeme memeeIsEdited: Bool) {
        // Refresh the scene
    }
    
    
    // MARK: - Helper Methods
    
    // Navigate to the MemeEditor when needed
    func navigateToMemeEditorView() {
        var memeEditorViewController: MemeEditorViewController
        memeEditorViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        // Send the meme
        memeEditorViewController.oldMeme = self.meme
        
        // Set the editor to be this cotroller's delegate
        memeEditorViewController.memeEditorDelegate = self
        
        self.present(memeEditorViewController, animated: true, completion: nil)
    }
    
    private func deleteTheMeme() {
        coreDataStack.context.delete(meme)
        
        // Persist the context to the disk
        coreDataStack.save()
        
        // Return back to the table/collection view controller
        self.navigationController!.popViewController(animated: true)
    }
    
    
    // MARK: - UI Configurations
    
    func configureUI() {
        // Hide the tab bar
        tabBarController?.tabBar.isHidden = true
        
        // Initialize the view's background color to white
        view.backgroundColor = .white
        
        // Initialize and configure the tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
    }
}
