//
//  AppDelegate.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
       
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }

    // MARK: - Core Data stack

    func deleteIterm()
    {
        let supportDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbUrl = supportDirectory.appendingPathComponent("SpaceOPracticalByHardik.sqlite")
        print("dbUrl",dbUrl)
        do {
            try self.persistentStoreCoordinator.destroyPersistentStore(at: dbUrl, ofType: NSSQLiteStoreType, options: nil);
        } catch {
            print(error);
        }
        do {
            try self.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbUrl, options: nil);
        } catch {
            print(error);
        }
    }
    
    
    lazy var applicationDocumentsDirectory: URL =
        {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "SpaceOPracticalByHardik", withExtension: "momd")
        print(modelURL ?? "")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SpaceOPracticalByHardik")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        var options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        let supportDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = supportDirectory.appendingPathComponent("SpaceOPracticalByHardik.sqlite")
        print(url)
        var failureReason = "There was an error creating or loading the application's saved data."
        if !(FileManager.default.fileExists(atPath: supportDirectory.path))
        {
            print("[Debug] Could not find \(supportDirectory). Will create now.")
            do
            {
                try FileManager.default.createDirectory(at: supportDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                let nserror = error as NSError
                print("withMessage:Could not create the necessary ApplicationSupport directory for the SQLite database. \(error)")
            }
        }
        do
        {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        }
        catch
        {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.spaceO.hardikPatel", code: 9999, userInfo: dict)
            print("withMessage: Unresolved persistantStoreCoordinator error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        let mergePolicy = NSMergePolicy(merge:NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType )
        managedObjectContext.mergePolicy = mergePolicy
        
        return managedObjectContext
    }()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

