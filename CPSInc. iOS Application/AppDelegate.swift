//
//  AppDelegate.swift
//  CPSInc. iOS Application
//
//  Created by Colton on 2019-05-24.
//  Copyright © 2019 Creative Protein Solutions Inc. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity
import SwiftyDropbox
import UserNotifications

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    public var window: UIWindow?
    private var wcSession: WCSession? = nil
    private var firstView: MenuViewController? = nil
    private var loginView: LoginViewController? = nil
    private var navigationController: UINavigationController? = nil
    private let notificationCenter = UNUserNotificationCenter.current()
    
    //User Defaults
    private let defaults = UserDefaults.standard


    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //register sync default on launch - will only happen if these have not been created on the device before
        defaults.register(defaults: ["syncUpToDateDefault": true])
        
        firstView = MenuViewController(appDelegate: self)
        loginView = LoginViewController()
        navigationController = UINavigationController(rootViewController: firstView!)
        navigationController!.navigationBar.barTintColor = .blue
        
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        //setup WatchConnectivity session - do it here so that it is setup before the application is displayed
        if (WCSession.isSupported()) {
            wcSession = WCSession.default
            wcSession!.delegate = firstView
            wcSession!.activate()
            firstView!.setWCSession(session: wcSession)
            //print("wcSession has been activated on mobile - MenuViewController")
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
        DropboxClientsManager.setupWithAppKey("ml7w1ed7ooeqyqa")
        
        return true
    }
    
    
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
                
                //not sure this is the best way to handle this - look into it
                firstView!.getHerdLogbookView().importAfterDropboxConnection()
                
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        
        //print("DELEGATE RETURINING ////////////////////////") //this worked
        return true
    }
    
    

    public func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    
    //User Notifications
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Test Finished Notification" {
            navigationController?.popToRootViewController(animated: true)
            navigationController?.pushViewController((firstView?.getTestView())!, animated: true)
        }
        else if response.notification.request.identifier == "Local Device Discovered Notification"{
            navigationController?.popToRootViewController(animated: true)
            navigationController?.pushViewController((firstView?.getConnectView())!, animated: true)
        }
        else if response.notification.request.identifier == "Local Timer Almost Done Notification"{
            navigationController?.popToRootViewController(animated: true)
            navigationController?.pushViewController((firstView?.getTestView())!, animated: true)
        }
        else if response.notification.request.identifier == "Import Complete Notification"{
            navigationController?.popToRootViewController(animated: true)
            navigationController?.pushViewController((firstView?.getHerdLogbookView())!, animated: true)
        }
        
        completionHandler()
    }
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if(notification.request.identifier == "Local Test Finished Notification" /*&& navigationController?.visibleViewController != firstView?.getTestView()*/){ //jeroen wants this to show from the view
            completionHandler([.alert, .sound])
        }
        else if(notification.request.identifier == "Local Device Discovered Notification" && navigationController?.visibleViewController != firstView?.getConnectView()){
            completionHandler([.alert, .sound])
        }
        else if(notification.request.identifier == "Local Timer Almost Done Notification" /*&& navigationController?.visibleViewController != firstView?.getTestView()*/){ //jeroen wants this to show from the view
            completionHandler([.alert, .sound])
        }
        else if(notification.request.identifier == "Import Complete Notification" && navigationController?.visibleViewController != firstView?.getHerdLogbookView()){
            completionHandler([.alert, .sound])
        }
        else{
            return
        }
        
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CPSInc__iOS_Application")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            else{
                let description = NSPersistentStoreDescription()
                description.shouldMigrateStoreAutomatically = false
                description.shouldInferMappingModelAutomatically = true
                container.persistentStoreDescriptions = [description]
            }
        })
        
        
        
        return container
    }()
    
    
    

    
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                self.setSyncUpToDate(upToDate: false)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        
    }
    
    
    
    //getters/setters
    public func getNotificationCenter() -> UNUserNotificationCenter{
        return notificationCenter
    }
    
    public func setSyncUpToDate(upToDate: Bool){
        defaults.set(upToDate, forKey: "syncUpToDateDefault")
        firstView?.setSyncUpToDate(upToDate: upToDate)
    }
    
    public func getSyncUpToDate() -> Bool{
        return defaults.bool(forKey: "syncUpToDateDefault")
    }
}

