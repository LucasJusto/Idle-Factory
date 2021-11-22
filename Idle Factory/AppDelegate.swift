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
        window = UIWindow()
        if OnboardingManager.shared.isFirstLaunch {
            CKRepository.getUserId { userID in
                if let userID = userID {
                    CKRepository.getUserById(id: userID) { _ in
                    }
                }
            }
            let storyboard = UIStoryboard(name: "OnboardingScene", bundle: .main)
            let viewcontroller : UIViewController = storyboard.instantiateViewController(withIdentifier: "welcome") as UIViewController
            window?.rootViewController = viewcontroller
            GameSound.shared.saveBackgroundMusicSettings(status: true)
            GameSound.shared.startBackgroundMusic()
            GameSound.shared.saveSoundFXSettings(status: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let viewcontroller = storyboard.instantiateInitialViewController()
            window?.rootViewController = viewcontroller
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        if GameSound.shared.backgroundMusicStatus {
            GameSound.shared.stopBackgroundMusic()
        }
        guard UIApplication.shared.windows.first?.rootViewController as? GameViewController != nil
        else {
            return
        }
        self.identifier = application.beginBackgroundTask {
            
        }
        
        GameViewController.scene?.background.removeAllChildren()
        let semaphore = DispatchSemaphore(value: 0)
        checkMyOffers(semaphore: semaphore)
        semaphore.wait()
        guard let user = GameScene.user
        else {
            return
        }
        user.timeLeftApp = AppDelegate.gameSave.transformToSeconds(time: AppDelegate.gameSave.getCurrentTime())
        CKRepository.currentUserQuickSave(user: user, userGenerators: user.generators, deletedGenerators: []) { _, _, _ in
            application.endBackgroundTask(self.identifier)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if GameSound.shared.backgroundMusicStatus {
            GameSound.shared.startBackgroundMusic()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        guard let viewController = UIApplication.shared.windows.first?.rootViewController as? GameViewController, viewController.isViewLoaded
        else {
            return
        }
        viewController.reload()
    }
}

