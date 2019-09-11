//
//  JSONProcessingSubOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation

public final class JSONProcessingSubOperation: BaseOperation, NetworkingSubOperation {
    
    public var networkingContext: NetworkingContext
    
    public init(networkingContext context: NetworkingContext) {
        self.networkingContext = context
    }
    
    public override func start() {
        super.start()
        operationBeganExecuting()
        
        guard networkingContext.error == nil else {
            operationFinishedExecuting()
            return
        }
        
        guard let data = networkingContext.data else {
            networkingContext.error = NSError(domain: "networking.json", code: 0, userInfo: [NSLocalizedDescriptionKey : "No data in context. Can't parse JSON"])
            operationFinishedExecuting()
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            networkingContext.intermediateObjects = json
        } catch let error as NSError {
            networkingContext.error = error
        }
        
        operationFinishedExecuting()
    }
}
