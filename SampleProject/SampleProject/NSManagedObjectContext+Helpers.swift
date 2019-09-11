//
//  NSManagedObjectContext+Helpers.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//
import Foundation
import CoreData

extension NSManagedObjectContext {

    ///generic method to create a core data object
    func insertObject<A: NSManagedObject>() -> A {
        if #available(iOS 10.0, *) {
            return A(context: self)
        } else {
            // remove this when we stop supporting ios9!
            guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.className, into: self) as? A else { fatalError("Could not create that object!  Wrong Object Type!") }
            return obj
        }
    }

    func deleteObjects(setOfObjects set: NSSet?) {
        guard let set = set else { return }
        for object in set {
            switch object {
            case let managedObject as NSManagedObject:
                self.delete(managedObject)
            default:
                fatalError("I'm trying to delete a non managed object!")
            }
        }
    }

    ///attempts to save, and performs a rollback if an exception is thrown.  returns whether the save was successful or not.
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    ///pass in a block of changes, and this will automatically attempt to save after running the block.
    func performChanges(save shouldSave: Bool, block: @escaping () -> ()) {
        perform { 
            block()
            if shouldSave {
                _ = self.saveOrRollback()
            }
        }
    }
    
    ///pass in a block of changes, and this will automatically attempt to save after running the block, but will wait to return until after saving.
    func performChangesAndWait(save shouldSave: Bool, block: @escaping () -> ()) {
        performAndWait {
            block()
            if shouldSave {
                _ = self.saveOrRollback()
            }
        }
    }
    
}
