//
//  MemesDetailViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/26/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemesDetailViewController: UIViewController {
    
    var meme: Meme!
    
    private var tapRecognizer: UITapGestureRecognizer? = nil
    
    // Use to show/hide the status bar
    var statusBarIsHidden = false
    
    override var prefersStatusBarHidden: Bool {
        // Show/Hide the status bar
        return statusBarIsHidden
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.image = meme.image?.getMemedImage()
        
        // Add the tap recognizer
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: - Tab Recognizer Methods
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        // Toggle the status bar
        statusBarIsHidden = !statusBarIsHidden
        setNeedsStatusBarAppearanceUpdate()
        
        // Toggle the navigation bar
        navigationController?.navigationBar.isHidden = !(navigationController?.navigationBar.isHidden ?? false)
        
        // Toggle the view's background color
        if view.backgroundColor == .white {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
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
