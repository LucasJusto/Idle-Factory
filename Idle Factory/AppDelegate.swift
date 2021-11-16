//
//  AppDelegate.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 12/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var gameSave: GameSave = GameSave()
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        self.identifier = application.beginBackgroundTask {
            
        }
        GameViewController.scene?.background.removeAllChildren()
        CKRepository.currentUserQuickSave(user: GameScene.user!, userGenerators: GameScene.user!.generators, deletedGenerators: []) { _, _, _ in
            application.endBackgroundTask(self.identifier)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.reload(gameSave: AppDelegate.gameSave)
        
    }
    
    
}

