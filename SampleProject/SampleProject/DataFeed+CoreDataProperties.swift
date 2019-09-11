//
//  DataFeed+CoreDataProperties.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import CoreData


extension DataFeed {

    @NSManaged public var isCurrent: Bool
    @NSManaged public var id: String?
    @NSManaged public var rewards: NSSet?

}

