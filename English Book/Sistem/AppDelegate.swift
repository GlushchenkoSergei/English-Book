//
//  AppDelegate.swift
//  English Book
//
//  Created by mac on 11.07.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
        return true
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
    
    
    
//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "hangge_1841")
//
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//
//            }
//
//        })
//
//        return container
//
//    }()
//
//
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//
//        let context = persistentContainer.viewContext
//
//        if context.hasChanges {
//
//            do {
//
//                try context.save()
//
//            } catch {
//
//                let nserror = error as NSError
//
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//
//            }
//
//        }
//
//    }
    
}
