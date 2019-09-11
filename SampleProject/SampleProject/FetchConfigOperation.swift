//
//  FetchConfigOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation

class FetchConfigOperation: BaseNetworkingOperation {

    convenience init(store: Store) {
        self.init()

        if let path = Bundle.main.path(forResource: "rewardsConfig", ofType: "json") {
            if let data = NSData(contentsOfFile:path) {
                networkingContext.data = data as Data
            }
        }

        let processingOperation = JSONProcessingSubOperation(networkingContext: networkingContext)
        let storingOperation = ConfigStoringOperation(networkingContext: networkingContext)

        self.subOperations = [processingOperation, storingOperation]
    }
}

class ConfigStoringOperation: BaseOperation, NetworkingSubOperation {

    let networkingContext: NetworkingContext
    
    required init(networkingContext context: NetworkingContext) {
        networkingContext = context
    }
    
    override func start() {
        operationBeganExecuting()

        if let configDict = networkingContext.intermediateObjects as? [String: AnyObject] {
            _ = ConfigManager.sharedInstance.updateConfig(configDict)
        }
        
        operationFinishedExecuting()
    }
}
