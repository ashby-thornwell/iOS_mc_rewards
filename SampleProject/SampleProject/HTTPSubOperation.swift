//
//  HTTPSubOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//
import UIKit

open class HTTPSubOperation: BaseOperation, NetworkingSubOperation {
    
    public let networkingContext: NetworkingContext
    open var session = URLSession.shared
    open var task: URLSessionTask? = nil
    
    public required init(networkingContext context: NetworkingContext) {
        networkingContext = context
    }
    
    override open func start() {
        operationBeganExecuting()

        guard let url = networkingContext.url else {
            networkingContext.error = NSError(domain: "networking.http", code: 0, userInfo: [NSLocalizedDescriptionKey : "No URL in context, can't do HTTP"])
            operationFinishedExecuting()
            return
        }
        
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request, completionHandler: {
            [weak self] (data, response, error) -> Void in

            if let error = error {
                self?.networkingContext.error = error as NSError;
            } else {
                self?.networkingContext.data = data
            }
            
            self?.operationFinishedExecuting()
            self?.task = nil
        }) 
        self.task = task
        task.resume()

    }

    override open func cancel() {
        super.cancel()
        
        if let task = task {
            task.cancel()
        }
    }
}
