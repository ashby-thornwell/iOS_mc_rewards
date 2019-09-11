//
//  Utils.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

func applicationDocumentsDirectory() -> URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
}

public extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }


        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block()
    }
}

extension Dictionary {

    mutating func update(_ other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension UIColor {

    static func tabItemBlue() -> UIColor {
        return UIColor(red:0.00, green:0.624, blue:0.859, alpha:1.00)
    }
}
