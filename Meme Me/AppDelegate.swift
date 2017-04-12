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

        /*
         // Start Autosaving (every 1 minute)
         coreDataStack.autoSave(60)
         */
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        /*
        // Persisit the memes to the disc
        coreDataStack.save()
        */
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        /*
         // Persisit the memes to the disc
         coreDataStack.save()
         */
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

