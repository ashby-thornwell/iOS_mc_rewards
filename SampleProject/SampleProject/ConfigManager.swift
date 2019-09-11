//
//  ConfigManager.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation


open class ConfigManager {
    public static let sharedInstance = ConfigManager()
    
    fileprivate var _config: [String: AnyObject]
    
    public init() {
        let path = applicationDocumentsDirectory().appendingPathComponent("config.json")
        if let data = try? Data(contentsOf: path), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let unwrappedJson = json {
            _config = unwrappedJson
        }
        else {
            _config = [:]
        }
    }
    
    fileprivate var endpoints: [String: AnyObject] {
        return _config["endpoints"] as? [String: AnyObject] ?? [:]
    }
    
    open func updateConfig(_ config: [String: AnyObject]) -> Bool {
        _config = config

        let path = applicationDocumentsDirectory().appendingPathComponent("config.json")
        if let data = try? JSONSerialization.data(withJSONObject: config, options: []) {
            return ((try? data.write(to: path, options: [.atomic])) != nil)
        }
        
        return false
    }
    
    open func endPointForKey(_ key: String) -> Endpoint? {
        if let endpoint = endpoints[key] as? [String: AnyObject] {
            return Endpoint(endPointDictionary: endpoint)
        }
        
        return nil
    }
    
    fileprivate func URLForValue(_ object: AnyObject?) -> URL? {
        if let string = object as? String {
            return URL(string: string)
        }
        
        return nil
    }
}
