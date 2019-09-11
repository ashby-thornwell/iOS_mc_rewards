//
//  Events.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import Foundation
public protocol Disposable {
    func dispose()
    func addDisposableTo(_ bag: DisposableBag)
}
extension Disposable {
    public func addDisposableTo(_ bag: DisposableBag) {
        bag.insert(self)
    }
}
/**
 A container for Disposable objects. Keeps track of Disposables, and can easily dispose of them when `dispose()` is invoked, or when this object is dealloced.
 */
open class DisposableBag {

    fileprivate var disposables = [Disposable]()

    /**
     Adds an object to the Dispose Bag.
     */
    func insert(_ disposable: Disposable) {
        disposables.append(disposable)
    }

    /**
     Calls `dispose()` on each Disposable, and removes them from the Dispose bag.
     */

    func dispose() {
        disposables = disposables.filter { (disposable) -> Bool in
            disposable.dispose()
            return false
        }
    }

    deinit {
        dispose()
    }
}

/**
 Event is a template class which represents an action of an object. When an object triggers it’s event by calling `raise`, attached EventHandlers are invoked. EventHandlers will be called on the thread that the event is fired from, and are expected to respond synchronously.
 */
open class Event<T> {

    public typealias EventHandler = (T) -> ()

    var eventHandlers = [Invocable]()
    fileprivate var closed = false

    public init() {
    }

    /**
     Invokes EventHandlers with the provided data

     - parameter data: Data relevent to the event, passed to EventHandlers

     */
    open func raise(_ data: T) {
        guard !closed else { return }
        for handler in eventHandlers {
            handler.invoke(data)
        }
    }

    /**
     Adds an EventHandler to the event.

     - parameter target: Target of the handler. The handler will not fire if the target is released.

     - parameter handler: Instance method of the target, invoked when the event is raised.

     - returns: Disposable reference, used to remove the newly added event handler from the event.
     */
    open func addHandler<U: AnyObject>(_ target: U, handler: @escaping (U) -> EventHandler) -> Disposable {
        let wrapper = EventMethodHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }

    /**
     Adds an EventHandler to the event.

     - parameter target: Target of the handler. The handler will not fire if the target is released.

     - parameter handler: Closure invoked when the event is raised.
     - returns: Disposable reference, used to remove the newly added event handler from the event.

     */

    open func addHandler<U: AnyObject>(_ target: U, handler: @escaping EventHandler) -> Disposable {
        let wrapper = EventClosureHandlerWrapper(target: target, handler: handler, event: self)
        eventHandlers.append(wrapper)
        return wrapper
    }

    /**
     Ensures that the event can no longe be raised, and removes all event handlers
     */
    open func close() {
        eventHandlers = []
        closed = true
    }
}

protocol Invocable: class {
    func invoke(_ data: Any)
}

private class EventClosureHandlerWrapper<T: AnyObject, U> : Invocable, Disposable {
    weak var target: T?
    let handler: (U) -> ()
    weak var event: Event<U>?

    init(target t: T?, handler h: @escaping (U) -> (), event e: Event<U>) {
        target = t
        handler = h
        event = e
    }

    func invoke(_ data: Any) -> () {
        if let _ = target {
            handler(data as! U)
        }
    }

    func dispose() {
        if let event = self.event {
            event.eventHandlers = event.eventHandlers.filter { $0 !== self }
        }
    }
}
private class EventMethodHandlerWrapper<T: AnyObject, U> : Invocable, Disposable {
    weak var target: T?
    let handler: (T) -> (U) -> ()
    weak var event: Event<U>?

    init(target t: T?, handler h: @escaping (T) -> (U) -> (), event e: Event<U>) {
        target = t
        handler = h
        event = e
    }

    func invoke(_ data: Any) -> () {
        if let t = target {
            handler(t)(data as! U)
        }
    }

    func dispose() {
        if let event = self.event {
            event.eventHandlers = event.eventHandlers.filter { $0 !== self }
        }
    }
}

