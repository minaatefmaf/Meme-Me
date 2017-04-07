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
    
    // Use to show/hide the status bar
    var statusBarIsHidden = false
    //self.setNeedsStatusBarAppearanceUpdate()
    
    override var prefersStatusBarHidden: Bool {
        // Show/Hide the status bar
        return statusBarIsHidden
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.image = meme.image?.getMemedImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the image
        self.imageView!.image = meme.image?.getMemedImage()
        
        // Configure the UI
        configureUI()
    }
    
    // MARK: - UI Configurations
    
    func configureUI() {
        // Hide the tab bar
        self.tabBarController?.tabBar.isHidden = true
        // Temporarly hide the navigation bar
        self.navigationController?.navigationBar.isHidden = true
    }
}
