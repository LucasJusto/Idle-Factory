//
//  AppDelegate.swift
//  Idle Factory
//
//  Created by Lucas Dimer Justo on 12/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var gameSave: GameSave = GameSave()
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        gameSave.saveTimeLeftApp()
    }
    
    var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        self.identifier = application.beginBackgroundTask {
            
        }
        CKRepository.storeUserData(id: GameScene.user!.id , name:  GameScene.user?.name ?? "", mainCurrency:  GameScene.user!.mainCurrency , premiumCurrency:  GameScene.user!.premiumCurrency, timeLeftApp: gameSave.transformToSeconds(time: gameSave.getCurrentTime()) , completion: {_,_ in
            print(#function)
            application.endBackgroundTask(self.identifier)
        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let viewController = UIApplication.shared.windows.first!.rootViewController as! GameViewController
        viewController.reload(gameSave: gameSave)
        
    }
    
    
}

