//
//  MemesCollectionViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import CoreData

class MemesCollectionViewController: CoreDataCollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 0.0
        let dimension = min((view.frame.size.width - (2 * space)) / 3.0,
                            (view.frame.size.height - (2 * space)) / 3.0)
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
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
        
        // Switch to the meme creation scene if the table is empty
        switchToMemeCreationIfEmptyResults()
        
        // Configure the UI
        configureUI()
        
    }
    
    @IBAction func addMeme(_ sender: UIBarButtonItem) {
        // Navigate to the MemeEditor
        navigateToMemeEditorView()
    }
    
    
    // MARK: - UICollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get the meme
        let meme = fetchedResultsController!.object(at: indexPath) as! Meme
        
        // Create the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        // Set the image
        cell.memedImageView.image = meme.getThumbnailImage()
        // Add a little curvature to the image corners to make a rounded corners
        cell.memedImageView.layer.cornerRadius = 8.0
        cell.memedImageView.clipsToBounds = true
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    func switchToMemeCreationIfEmptyResults() {
        // If there are no results for the fetch, navigate to the meme creation scene
        if fetchedResultsController?.sections![0].numberOfObjects == 0 {
            navigateToMemeEditorView()
        }
    }
    
   
    // MARK: - UI Configurations
    
    func configureUI() {
        // Show the navigation bar
        navigationController?.navigationBar.isHidden = false
        
        // Show the tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
