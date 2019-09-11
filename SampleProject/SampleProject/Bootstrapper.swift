//
//  StartupManager.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
import UIKit 

class Bootstrapper {
    typealias BootstrapCompletionHandler = (() -> Void)
    typealias EndpointDesc = (name: String?, args: [String:String]?)
    
    var configManager: ConfigManager { return ConfigManager.sharedInstance }
    var mainQueue: OperationQueue?
    
    var store: Store?
    var configOperationComplete = false

    var refreshTimer: Timer?
    
    var refreshOperation: Operation!
    
    fileprivate var dataEndpointDesc: EndpointDesc = (nil, nil)
    fileprivate var dataFeedOperation: FetchDataFeedOperation?
    
    fileprivate var newsEndpointDesc: EndpointDesc = (nil, nil)

    
    init() {
    }
    
    fileprivate func resetQueue() {
        
        dataFeedOperation?.cancel()
        dataFeedOperation = nil
        
        mainQueue?.cancelAllOperations()
        mainQueue = OperationQueue()
        mainQueue?.maxConcurrentOperationCount = 1
        
        refreshTimer?.invalidate()
    }
        
    func startUp(_ viewController: UIViewController, force: Bool = false, completionHandler: BootstrapCompletionHandler?) {
        guard let store = store else { return }
        
        resetQueue()
        
        let configOperation = FetchConfigOperation(store: store)

        configOperation.completionBlock =  {
            self.configOperationComplete = true
            self.loadFeeds(force: force, completionHandler: completionHandler)
        }
        
        mainQueue?.addOperations([configOperation], waitUntilFinished: false)
        
        refreshTimer = Timer.scheduledTimer( timeInterval: 5, target: self, selector: #selector(checkForUpdates),
                               userInfo: nil, repeats: true)
    }
    
    func loadFeeds(force: Bool = false, completionHandler: BootstrapCompletionHandler? = nil) {

        loadDataEndpoint(dataEndpointDesc)
        if let completionHandler = completionHandler {
            mainQueue?.addOperation(BlockOperation(block: completionHandler) )
        }
    }
    
    func loadDataEndpoint(_ endpointName: String?, args: [String:String]? = nil, force: Bool = false) {
        loadDataEndpoint((endpointName, args), force: force)
    }
    
    func loadDataEndpoint(_ endpointDesc: EndpointDesc, force: Bool = false) {
        dataEndpointDesc = endpointDesc
        if let store = store, var endpoint =  configManager.endPointForKey( endpointDesc.name ?? "feed"), dataFeedOperation == nil {
            endpoint.replacementTokens = endpointDesc.args
            
            dataFeedOperation = FetchDataFeedOperation(endpoint: endpoint, store: store, force: force)
            dataFeedOperation?.completionBlock = { self.dataFeedOperation = nil }
            mainQueue?.addOperation(dataFeedOperation!)
        }
    }

    @objc fileprivate func checkForUpdates() {
        if var dataEndpoint = configManager.endPointForKey(dataEndpointDesc.name ?? "feed") {
            dataEndpoint.replacementTokens = dataEndpointDesc.args
            if dataEndpoint.isExpired() && dataEndpoint.autoRefresh == true {
                loadDataEndpoint(dataEndpointDesc)
            }
        }
    }
}
