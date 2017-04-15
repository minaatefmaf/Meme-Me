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
    @IBOutlet weak var shareBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the core data stack
        coreDataStack = delegate.coreDataStack
        
        // Add the right bar button
        addNewMemeButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MemesDetailViewController.navigateToMemeEditorView))
        navigationItem.setRightBarButtonItems([addNewMemeButton], animated: false)
        
        // Add the image
        imageView!.image = meme.image?.getMemedImage()
        
        // Configure the UI
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add the tap recognizer
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the tap recognizer
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    @IBAction func shareMemedImage(_ sender: UIBarButtonItem) {
        // Define an instance of the ActivityViewController
        let activityController = UIActivityViewController(activityItems: [self.imageView!.image as Any], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { [weak weakSelf = self] _ in
            // Make sure the delete button is enabled (for the iPad case)
            weakSelf?.deleteBarButton.isEnabled = true
        }

        // For iPads, telling them where to attach the popover (the action sheet replaceable there)
        activityController.popoverPresentationController?.barButtonItem = shareBarButton
        
        // Make sure the delete button is disabled (for the iPad case)
        deleteBarButton.isEnabled = false
        
        // Present the ActivityViewController
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonIsPressed(_ sender: Any) {
        // Prepare an alert to confirm the meme deletion
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Prepare the actions
        let deleteAction = UIAlertAction(title: Alerts.DeleteMeme, style: UIAlertActionStyle.destructive) { [weak weakSelf = self] _ in
            // Delete the meme
            weakSelf?.deleteTheMeme()
        }
        let cancelAction = UIAlertAction(title: Alerts.Cancel, style: UIAlertActionStyle.cancel) { [weak weakSelf = self] _ in
            // Make sure the share button is enabled (for the iPad case)
            weakSelf?.shareBarButton.isEnabled = true
        }

        // Add the actions
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // For iPads, telling them where to attach the popover (the action sheet replaceable there)
        alert.popoverPresentationController?.barButtonItem = deleteBarButton
        
        // Make sure the share button is disabled (for the iPad case)
        shareBarButton.isEnabled = false
        
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
    
    func editTheMeme(MemeEditor: MemeEditorViewController, didEditMeme memeIsEdited: Bool, newMeme: Meme?) {
        // Update the scene using the new meme data
        if memeIsEdited {
            // Update the meme
            meme = newMeme!
            
            // Update the image
            imageView!.image = meme.image?.getMemedImage()
            
            // Update the navigation bar's title
            setNavigationBarTitle()
        }
    }
    
    
    // MARK: - Helper Methods
    
    // Navigate to the MemeEditor when needed
    func navigateToMemeEditorView() {
        var memeEditorViewController: MemeEditorViewController
        memeEditorViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        // Send the meme to be edited
        memeEditorViewController.oldMeme = self.meme
        
        // Set the sceneMode of the memeEditorViewController to the modifying old meme mode
        memeEditorViewController.sceneMode = .modifyOldMeme
        
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
    
    private func setNavigationBarTitle() {
        // Prepare the date in a human readable format
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        let dateString = formatter.string(from: meme.createdAt as! Date)
        
        // Set the title to the date the meme was created
        navigationItem.title = dateString
    }
    
    
    // MARK: - UI Configurations
    
    func configureUI() {
        // Hide the tab bar
        tabBarController?.tabBar.isHidden = true
        
        // Initialize the view's background color to white
        view.backgroundColor = .white
        
        // Set the navigation bar's title
        setNavigationBarTitle()
        
        // Initialize and configure the tap recognizer
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
    }
}
