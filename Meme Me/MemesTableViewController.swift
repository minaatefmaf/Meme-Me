//
//  MemesTableViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import CoreData

class MemesTableViewController: CoreDataTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the core data stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = delegate.coreDataStack
        
        // Create a fetchrequest
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Meme.Keys.EntityName)
        // Sort the items by the meme creation date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataStack.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure the UI
        configureUI()
    }
    
    @IBAction func addMeme(_ sender: UIBarButtonItem) {
        // Navigate to the MemeEditor
        navigateToMemeEditorView()
    }
    
    
    // MARK: - UITableView Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get the meme
        let meme = fetchedResultsController!.object(at: indexPath) as! Meme
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        // Set the text
        cell.labelTop.text = meme.topText
        cell.labelBottom.text = meme.bottomText
        
        // Set the date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: meme.createdAt as! Date)
        cell.dateLabel.text = dateString
        
        // Set the image
        cell.memedImageView.image = meme.getThumbnailImage()
        // Add a little curvature to the image corners to make a rounded corners
        cell.memedImageView.layer.cornerRadius = 8.0
        cell.memedImageView.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemesDetailViewController") as! MemesDetailViewController
        
        // Set the meme
        detailController.meme = fetchedResultsController!.object(at: indexPath) as! Meme
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    // MARK: - Helper Methods
    
    // Navigate to the MemeEditor when needed
    func navigateToMemeEditorView() {
        var controller: MemeEditorViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    // MARK: - UI Configurations
    
    func configureUI() {
        // Show the navigation bar
        navigationController?.navigationBar.isHidden = false
            
        // Show the tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
