//
//  BaseNetworkingOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation

public protocol NetworkingSubOperation: class {
    var networkingContext: NetworkingContext { get }
    init(networkingContext: NetworkingContext)
}

open class BaseNetworkingOperation: GroupOperation  {
    
    public let networkingContext = NetworkingContext()
    
    public init() {
        super.init(serial: true)
    }
}
