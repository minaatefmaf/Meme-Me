//
//  MemesDetailViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/26/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemesDetailViewController: UIViewController {
    
    @IBOutlet weak var buttomToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
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
