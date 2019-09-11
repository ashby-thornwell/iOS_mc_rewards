//
//  NotifyingSubOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation

open class NotifyingSubOperation: BaseOperation {
    
    public let networkingContext: NetworkingContext
    let successNotificationName: String
    let failureNotificationName: String?
    
    public init(context: NetworkingContext, successName: String, failureName: String?) {
        networkingContext = context
        successNotificationName = successName
        failureNotificationName = failureName
    }
    
    override open func start() {
        super.start()
        operationBeganExecuting()
        
        DispatchQueue.main.async {
            if let error = self.networkingContext.error {
                if let failureNotificationName = self.failureNotificationName {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: failureNotificationName), object: error)
                }
            }
            else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: self.successNotificationName), object: nil)
            }
        }
        
        operationFinishedExecuting()
    }
}
