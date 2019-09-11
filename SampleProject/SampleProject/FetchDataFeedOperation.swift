 //
 //  FetchDataFeedOperation.swift
 //  SampleProject
 //
 //  Copyright © 2019 ashby thornwell. All rights reserved.
 //

import Foundation 

// MARK:  Struct

struct DataFeedKeys {
    static let title = "title"
    static let description = "description"
    static let imageURL = "imageURL"
    static let ordinal = "ordinal"
    static let rewards = "rewards"
    static let idDict = "_id"
    static let id = "$oid"
}

// MARK: Classes

class FetchDataFeedOperation: BaseNetworkingOperation {
    
    static let FetchComplete = "FetchDataFeedCompleteNotification"
    let endpoint: Endpoint
    var force: Bool = false

    init(endpoint: Endpoint, store: Store, force f: Bool) {
        self.endpoint = endpoint
        force = f
        
        super.init()
        
        if let path = Bundle.main.path(forResource: "rewards_test", ofType: "json") {
            if let data = NSData(contentsOfFile:path) {
                networkingContext.data = data as Data
            }
        }
        
//        let processingOperation = JSONProcessingSubOperation(networkingContext: networkingContext)
//        let storingOperation = ConfigStoringOperation(networkingContext: networkingContext)
//
//        self.subOperations = [processingOperation, storingOperation]
        
        
        let processingOperation = JSONProcessingSubOperation(networkingContext: networkingContext)
        let storingOperation = DataFeedStoringOperation(networkingContext: networkingContext)
        storingOperation.store = store
        let notifyOperation = NotifyingSubOperation(context: networkingContext, successName: FetchDataFeedOperation.FetchComplete, failureName: FetchDataFeedOperation.FetchComplete)

        let blockOp = BlockOperation {
            endpoint.recordSuccessfulRequest()
        }

        self.subOperations = [processingOperation, storingOperation, notifyOperation, blockOp]
    }
    
    override func start() {

        if endpoint.isExpired() || force {
            if let URL = endpoint.endPointURL() {
                networkingContext.url = URL
            }
        }
        else {
            operationFinishedExecuting()
            return
        }
        
        super.start()
    }

    override func cancel() {
        super.cancel()
        
        for op in queue.operations {
            op.cancel()
        }
    }
}

class DataFeedStoringOperation: BaseOperation, NetworkingSubOperation {
    
    let networkingContext: NetworkingContext
    var store: Store?
    var positionOffset: Int = 0
    
    required init(networkingContext context: NetworkingContext) {
        networkingContext = context
    }
    
    override func start() {
        super.start()
        operationBeganExecuting()
        
        guard networkingContext.error == nil else {
            operationFinishedExecuting()
            return
        }
        
        store?.privateContext.performAndWait {
        
            if let store = self.store, let json = self.networkingContext.intermediateObjects as? [[String: AnyObject]] {
                DataFeed.markAllDataFeedsNotCurrent(inManagedObjectContext: store.privateContext)
                self.parseDataFeedConfiguration(store, json: json)

                do {
                    try store.privateContext.save()
                }
                catch { }
            }
        }
        
        operationFinishedExecuting()
    }
    
    // MARK: Parse Methods

    func parseDataFeedConfiguration(_ store: Store, json: [[String: AnyObject]])  {
        let predicate = DataFeed.defaultPredicate(usingIdentifier: DataFeedKeys.rewards)
       _ = DataFeed.fetchOrCreate(inContext: store.privateContext, matchingPredicate: predicate) { dataFeed in
            dataFeed.id = DataFeedKeys.rewards
            dataFeed.isCurrent = true
            let rewards = Reward.createOrUpdateOffers(fromJson: json, inContext: store.privateContext)
            dataFeed.rewards = rewards
        }
    }
}
