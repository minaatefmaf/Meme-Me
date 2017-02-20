//
//  MemesCollectionViewController.swift
//  Meme Me
//
//  Created by Mina Atef on 5/25/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve the sent memes.
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
        
        // If the user has no sent memes, the MemeEditor is displayed first.
        if self.memes.count == 0 {
            navigateToMemeEditorView()
        }
        
        // Reload the rows and sections of the table view.
        collectionView.reloadData()
    }
    
    @IBAction func addMeme(_ sender: UIBarButtonItem) {
        // Navigate to the MemeEditor
        navigateToMemeEditorView()
    }
    
    // Navigate to the MemeEditor when needed
    func navigateToMemeEditorView() {
        var controller: MemeEditorViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        // Set the name and image
        let meme = self.memes[indexPath.row]
        cell.memedImageView?.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:IndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemesDetailViewController") as! MemesDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

    
}
