//
//  CoreDataCollectionViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 4/9/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import UIKit
import CoreData

class CoreDataCollectionViewController: UICollectionViewController {
    
    // Keep the changes; keep track of insertions, deletions, and updates.
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the fetchedResultsController changes, we execute the search and reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            collectionView!.reloadData()
        }
    }
    
    // MARK: Initializers
    
    /*
     init(fetchedResultsController fetchController: NSFetchedResultsController<NSFetchRequestResult>, style: UITableViewStyle = .plain) {
     fetchedResultsController = fetchController
     super.init(style: style)
     }
     */
    
    // This initializer has to be implemented because of the way Swift interfaces with the Objective C protocol NSArchiving.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

// MARK: - CoreDataCollectionViewController Method that Subclass Must Implement

extension CoreDataCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("This method MUST be implemented by a subclass of CoreDataCollectionViewController")
    }
}

// MARK: - Collection Data Source Methods

extension CoreDataCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController!.sections?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fetchedResultsController = fetchedResultsController {
            return fetchedResultsController.sections![section].numberOfObjects
        } else {
            return 0
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     if let fetchedResultsController = fetchedResultsController {
     return fetchedResultsController.sections![section].name
     } else {
     return nil
     }
     }
     
     
     override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
     if let fetchedResultsController = fetchedResultsController {
     return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
     } else {
     return 0
     }
     }
     
     
     override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
     if let fetchedResultsController = fetchedResultsController {
     return fetchedResultsController.sectionIndexTitles
     } else {
     return nil
     }
     }
     */
    
}

// MARK: - Fetches

extension CoreDataCollectionViewController {
    
    func executeSearch() {
        if let fetchedResultsController = fetchedResultsController {
            do {
                try fetchedResultsController.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate Methods

extension CoreDataCollectionViewController: NSFetchedResultsControllerDelegate {
    
    // Whenever changes are made to Core Data the following three methods are invoked. This first method is used to create three fresh arrays to record the index paths that will be changed.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // We are about to handle some new changes. Start out with empty arrays for each change type
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
        updatedIndexPaths = [IndexPath]()
    }
    
    // The second method may be called multiple times, once for each Photo object that is added, deleted, or changed.
    // We store the index paths into the three arrays.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type{
            
        case .insert:
            // Here we are noting that a new Photo instance has been added to Core Data. We remember its index path so that we can add a cell in "controllerDidChangeContent". Note that the "newIndexPath" parameter has the index path that we want in this case.
            insertedIndexPaths.append(newIndexPath!)
            break
        case .delete:
            // Here we are noting that a Photo instance has been deleted from Core Data. We keep remember its index path so that we can remove the corresponding cell in "controllerDidChangeContent". The "indexPath" parameter has value that we want in this case.
            deletedIndexPaths.append(indexPath!)
            break
        case .update:
            // Use this to update the photos when downloaded.
            updatedIndexPaths.append(indexPath!)
            break
        case .move:
            // Do nothing
            break
        }
    }
    
    // This method is invoked after all of the changed in the current batch have been collected into the three index path arrays (insert, delete, and upate). We now need to loop through the arrays and perform the changes.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView!.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.collectionView!.insertItems(at: [indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView!.deleteItems(at: [indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView!.reloadItems(at: [indexPath])
            }
            
        }, completion: nil)
    }

    
}

