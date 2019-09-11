//
//  ImageProcessingSubOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import UIKit

open class ImageProcessingSubOperation: BaseOperation, NetworkingSubOperation {
    
    public let networkingContext: NetworkingContext
    
    public required init(networkingContext context: NetworkingContext) {
        networkingContext = context
    }
    
    override open func start() {
        super.start()
        operationBeganExecuting()
        
        guard let data = networkingContext.data else {
            self.networkingContext.error = NSError(domain: "networking.image", code: -99, userInfo: [NSLocalizedDescriptionKey : "Failed to create image from data."])
            operationFinishedExecuting()
            return
        }
        
        let image = UIImage(data: data)
        networkingContext.intermediateObjects = image
        
        self.operationFinishedExecuting()
    }
}
