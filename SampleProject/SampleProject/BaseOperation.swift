//
//  BaseOperation.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation

open class BaseOperation: Foundation.Operation {
    
    // MARK: - NSOperation
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    // MARK: - Internal
    
    fileprivate var _executing: Bool = false
    override open var isExecuting: Bool {
        get { return _executing }
        set (executing) {
            willChangeValue(forKey: "isExecuting")
            _executing = executing
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    fileprivate var _finished: Bool = false
    override open var isFinished: Bool {
        get { return _finished }
        set (finished) {
            willChangeValue(forKey: "isFinished")
            _finished = finished
            didChangeValue(forKey: "isFinished")
        }
    }
    
    fileprivate var _cancelled: Bool = false
    override open var isCancelled: Bool {
        get { return _cancelled }
        set (cancelled) {
            willChangeValue(forKey: "isCancelled")
            _cancelled = cancelled
            didChangeValue(forKey: "isCancelled")
        }
    }
    
    override open func cancel() {
        isCancelled = true
    }
    
    open func operationBeganExecuting() {
        print("\(self) started")
        isFinished = false
        isExecuting = true
    }
    
    open func operationFinishedExecuting() {
        print("\(self) finished")
        isExecuting = false
        isFinished = true
    }

    override open func start() {
        super.start()
    }
}
