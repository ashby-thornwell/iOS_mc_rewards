//
//  Reward+CoreDataClass.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import CoreData


public class Reward: NSManagedObject, ManagedObjectType {

    static func createOrUpdateOffers(fromJson json: [[String : AnyObject]], inContext context: NSManagedObjectContext) -> NSSet {
        return flatMap(json: json, mappingFunction: {
            return createOrUpdateOffer(fromJson: $0, inContext: context)
        })
    }

    static func createOrUpdateOffer(fromJson json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Reward? {
        guard let idDictionary = json[DataFeedKeys.idDict] as? [String: AnyObject], let id = idDictionary[DataFeedKeys.id] as? String else { return nil }

        let predicate = NSPredicate(format: "id == %@", id)
        let reward = Reward.fetchOrCreate(inContext: context, matchingPredicate: predicate) { reward in
            reward.id = id
            reward.title = json[DataFeedKeys.title] as? String
            reward.rewardDescription = json[DataFeedKeys.description] as? String
            reward.imageURL = json[DataFeedKeys.imageURL] as? String

            if let ordinal = json[DataFeedKeys.ordinal] as? Int32 {
                reward.ordinal = ordinal
            }
        }
        return reward
    }

    static func allCurrentRewards(inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [Reward]?{

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reward")
        fetchRequest.predicate = NSPredicate(format: "dataFeed.isCurrent == 1")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "ordinal", ascending: false)]

        do {
            let rewards = try managedObjectContext.fetch(fetchRequest) as! [Reward]
            return rewards

        } catch {}
        
        return nil
    }

    static func fetchReward(id: String, context: NSManagedObjectContext) -> Reward? {
        let predicate = NSPredicate(format: "id == %@ && dataFeed.isCurrent == 1", id)
        if let reward = Reward.findOrFetch(inContext: context, matchingPredicate: predicate) {
            return reward
        }
        return nil
    }

    static func updateReward(id: String, isSaved: Bool, context: NSManagedObjectContext, completion: ((() -> ())?)) {
        context.performChanges(save: true) {
            if let reward: Reward = Reward.fetchReward(id: id, context: context) {
                reward.isSaved = isSaved
                completion?()
            }
        }
    }
}
