//
//  Endpoint.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//


import Foundation

enum EndpointType: String {
    case Feed = "feed"
}

public struct Endpoint {
    let urlString: String
    let cacheTime: TimeInterval
    let autoRefresh: Bool
    var replacementTokens: [String: String]?
    
    public func endPointURL() -> URL? {
        return URL(string: populatedEndPoint())
    }
    
    func populatedEndPoint() -> String {
        var populatedEndPoint = urlString
        
        if let replacementTokens = replacementTokens {
            for (key, value) in replacementTokens {
                populatedEndPoint = populatedEndPoint.replacingOccurrences(of: "{\(key)}", with: value)
            }
        }
        
        return populatedEndPoint
    }
    
    public func isExpired() -> Bool {
        let key = populatedEndPoint()
        let lastRequestTime = UserDefaults.standard.object(forKey: key) as? TimeInterval ?? 0
        let currentTime = Date().timeIntervalSince1970
        let delta = currentTime - lastRequestTime
        
        return (delta >= cacheTime)
    }
    
    public func recordSuccessfulRequest() {
        let key = populatedEndPoint()
        let currentTime = Date().timeIntervalSince1970
        
        UserDefaults.standard.set(currentTime, forKey: key)
    }
    
    public init(endPointDictionary dict: [String: AnyObject]) {
        urlString = dict["url"] as? String ?? ""
        cacheTime = dict["cache"] as? TimeInterval ?? 60
        autoRefresh = dict["autorefresh"] as? Bool ?? false
    }
}
