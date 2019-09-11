//
//  FetchImageOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import UIKit

class FetchImageOperation: BaseNetworkingOperation {
    static let FetchImageComplete = "FetchImageCompleteNotification"

    init(url: URL) {
        super.init()

        networkingContext.url = url

        let downloadingOperation = HTTPSubOperation(networkingContext: networkingContext)
        let imageProcessingOperation = ImageProcessingSubOperation(networkingContext: networkingContext)

        self.subOperations = [downloadingOperation, imageProcessingOperation]
    }
}
