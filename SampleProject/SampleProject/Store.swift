//
//  Store.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit
import CoreData

public enum StoreType {
    case inMemory
    case sqLite(URL)
}

open class Store {
    
    let persistentStoreCoordinator: NSPersistentStoreCoordinator!
    public let mainContext: NSManagedObjectContext!
    public let privateContext: NSManagedObjectContext!
    
    public init?(modelURL: URL, type: StoreType) {
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            printError("Could not load model at \(modelURL)")
            persistentStoreCoordinator = nil
            mainContext = nil
            privateContext = nil
            return nil
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
        switch type {
            case .inMemory:
                try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
                printSuccess("In memory store setup complete")
            case let .sqLite(url):
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
                printSuccess("SQLite store setup complete")
            }
        } catch {
            printError("Could not add persistent store, \(error)")
            persistentStoreCoordinator = nil
            mainContext = nil
            privateContext = nil
            return nil
        }

        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext!.persistentStoreCoordinator = coordinator
        mainContext!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext!.persistentStoreCoordinator = coordinator
        privateContext!.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        persistentStoreCoordinator = coordinator
        
        NotificationCenter.default.addObserver(self, selector: #selector(Store.contextDidSave(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    @objc func contextDidSave(_ notification: Notification) {
        guard let savedContext = notification.object as? NSManagedObjectContext else { return }
        
        if savedContext == mainContext {
            privateContext.performAndWait {
                self.privateContext.mergeChanges(fromContextDidSave: notification)
            }
        }
        else if savedContext == privateContext {
            DispatchQueue.main.async {
                self.mainContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
}

public extension Store {
    static func setSharedInstance(_ store: Store) {
        DispatchQueue.once {
            _sharedInstance = store
        }
    }
    
    fileprivate static var _sharedInstance: Store?
    static var sharedInstance: Store! {
        return _sharedInstance
    }
}
