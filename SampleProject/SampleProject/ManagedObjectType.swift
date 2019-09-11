//
//  ManagedObjectType.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//
import Foundation
import CoreData

protocol ManagedObjectType: class {
}

///add this protocol to any NSManagedObject to get rid of lots of boilerplate!
extension ManagedObjectType where Self: NSManagedObject {
    
    static func defaultPredicate(usingIdentifier identifier: String) -> NSPredicate {
        return NSPredicate(format: "id == %@", identifier)
    }
    
    /**
     looks for a materialized object, if nothing found it will go to do a fetch request, and if still nothing is
     found it will create an instance.  in all cases the configure block is run on the fetched or created instance.
     */
    static func fetchOrCreate(inContext context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        guard let existingObject = findOrFetch(inContext: context, matchingPredicate: predicate) else {
            return create(inContext: context, configure: configure)
        }
        configure(existingObject)
        return existingObject
    }

    ///creates a single ManagedObjectType and configures it with the configure block.
    static func create(inContext context: NSManagedObjectContext, configure: (Self) -> ()) -> Self {
        let createdObject: Self = context.insertObject()
        configure(createdObject)
        return createdObject
    }
    
    ///takes in a json array, a store, and a create function.  returns a set of objects since thats what core data likes.
    static func flatMap(json jsonArray: [[String: AnyObject]], mappingFunction mapper: ([String: AnyObject]) -> Self?) -> NSSet {
        return NSSet(array: jsonArray.compactMap({ mapper($0) }))
    }
    
    /// method to find one item.  uses the predicate passed in.
    static func findOrFetch(inContext context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        return fetch(inContext: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
    }
    
    ///fetches for objects based on the className and gives the ability to configure the fetch request.  runs in a perform block.
    static func fetch(inContext context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.className)
        configurationBlock(request)
        var result: [Self] = []
        context.performAndWait {
            guard let innerResult = try? context.fetch(request) as? [Self] else {
                return
            }
            result = innerResult ?? []
        }
        return result
    }

    /// deletes all objects that match the predicate.  runs in a perform block and saves after deletion.
    static func deleteAll(inContext context: NSManagedObjectContext) {
        
        context.performChangesAndWait(save: true) {
            let objectsToDelete = fetch(inContext: context) { _ in }
            for objectToDelete in objectsToDelete {
                context.delete(objectToDelete)
            }
        }
    }
}
