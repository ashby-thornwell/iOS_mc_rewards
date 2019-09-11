//
//  Reward+CoreDataProperties.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import CoreData


extension Reward {

    @NSManaged public var title: String?
    @NSManaged public var rewardDescription: String?
    @NSManaged public var ordinal: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var id: String?
    @NSManaged public var isSaved: Bool
    @NSManaged public var dataFeed: DataFeed?

}
