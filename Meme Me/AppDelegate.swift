//
//  AppDelegate.swift
//  Meme Me
//
//  Created by Mina Atef on 5/20/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let coreDataStack = CoreDataStack(modelName: "Model")!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set the initial tab bar view
        setInitialTabBarView()

        // If this is the first time the user launches the app, ask for the required permissions
        initializeTheAppForFirstLaunch()
        
        /*
         // Start Autosaving (every 1 minute)
         coreDataStack.autoSave(60)
         */
        
        return true
    }
    
    private func initializeTheAppForFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            // The app has launched before -> Do nothing
        } else {
            // This is the first launch ever, ask for the required permssions
            AppPermissions.askUserPermissionForThePhotoLibrary()
            AppPermissions.askUserPermissionForCamera()
            
            // Set "HasLaunchedBefore" to true
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - Getting The Initial View Controller Helper Methods
    
    func setInitialTabBarView() {
        // Get a reference to the root tab bar controller
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarControllerID") as! UITabBarController
        self.window?.rootViewController = initialViewController
        let tababarController = self.window!.rootViewController as! UITabBarController
        
        // Remember the last tab the user was using
        let defaults = UserDefaults.standard
        let rootTabReference = defaults.integer(forKey: "rootTabReference")
        
        // Start with that tab view
        tababarController.selectedIndex = rootTabReference
        
        self.window?.makeKeyAndVisible()
    }
    
}

