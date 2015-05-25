//
//  MemesTableViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve the sent memes.
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        
        if self.memes.count == 0 {
            navigateToMemeEditorView()
        }
        
        // Reload the rows and sections of the table view.
        tableView.reloadData()
    }
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
        
        // Set the name and image
        let meme = self.memes[indexPath.row]
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemesTableViewControllerDetail") as! MemesTableViewControllerDetail
        detailController.meme = self.memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}