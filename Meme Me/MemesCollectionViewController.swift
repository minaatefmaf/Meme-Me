//
//  MemesCollectionViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController {
    
    
    
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        // Navigate to the MemeEditor
        navigateToMemeEditorView()
    }
    
    // Navigate to the MemeEditor when needed
    func navigateToMemeEditorView() {
        var controller: MemeEditorViewController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
}