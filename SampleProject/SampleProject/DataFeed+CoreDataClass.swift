//
//  DataFeed+CoreDataClass.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class DataFeed: NSManagedObject, ManagedObjectType {
    // MARK: - Predicates

    static func predicate(isCurrent current: Bool) -> NSPredicate {
        return NSPredicate(format: "isCurrent == %@", NSNumber(value: current))
    }

    static func predicate(usingID feedID: String) -> NSPredicate {
        return NSPredicate(format: "id == %@", feedID)
    }

    // MARK: - Update

    static func setFeedsToNotCurrent(inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        managedObjectContext.performChangesAndWait(save: false) {
            let feedItems = fetch(inContext: managedObjectContext)
            for feedItem in feedItems {
                feedItem.isCurrent = false
            }
        }
    }

    static func markAllDataFeedsNotCurrent(inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DataFeed")
        do {
            let dataFeedConfigurations = try managedObjectContext.fetch(fetchRequest) as! [DataFeed]

            for dataFeedConfiguration in dataFeedConfigurations {
                dataFeedConfiguration.isCurrent = false
            }
        } catch {}
    }

    // MARK: - Fetch

    static func fetchAllFeedsWithName(feedID: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [DataFeed]? {
        return fetch(inContext: managedObjectContext) { fetchRequest in
            fetchRequest.predicate = predicate(usingID: feedID)
        }
    }

    static func fetchAllNonCurrentFeeds() -> [DataFeed]? {
        var nonCurrentFeeds: [DataFeed]?

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let store = appDelegate.bootstrapper.store else { return nil }
        store.privateContext.performChangesAndWait(save: false) {
            nonCurrentFeeds = fetch(inContext: store.privateContext) { fetchRequest in
                fetchRequest.predicate = predicate(isCurrent: false)
            }
        }
        return nonCurrentFeeds
    }


    // MARK: - Delete

    static func deleteNonCurrentFeeds() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let store = appDelegate.bootstrapper.store else { return }

        DataFeed.setFeedsToNotCurrent(inManagedObjectContext: store.privateContext)

        store.privateContext.performChangesAndWait(save: true) {
            guard let nonCurrentFeeds = DataFeed.fetchAllNonCurrentFeeds() else { return }
            for feed in nonCurrentFeeds {
                store.privateContext.delete(feed)
            }
        }
    }
}
