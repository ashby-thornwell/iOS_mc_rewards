//
//  GroupOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation

open class GroupOperation: BaseOperation {
    let queue = OperationQueue()
    open var subOperations = [Operation]()

    public init(serial: Bool) {
        queue.maxConcurrentOperationCount = serial ? 1 : OperationQueue.defaultMaxConcurrentOperationCount
    }
    
    open override func start() {
        super.start()
        operationBeganExecuting()
        
        subOperations.append(BlockOperation { [weak self] in
            self?.operationFinishedExecuting()
            })
        
        queue.addOperations(subOperations, waitUntilFinished: false)
    }
}
