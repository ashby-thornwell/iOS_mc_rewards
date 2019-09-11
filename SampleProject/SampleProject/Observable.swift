//
//  Observable.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//
import Foundation

/**
 Observable is a teplated class contains an object of the teplated type as it's value.
 An Observable contains a volitial object, which when changed, notifies change handlers of the
 Observable's new value.
 */
open class Observable<T> {

    let willChangeWithOldValue = Event<(T, T)>()
    let didChangeWithOldValue = Event<(T, T)>()
    let willChange = Event<T>()
    let didChange = Event<T>()

    /**
     Data contained within the Observable. When changes are made to this value,
     change handlers are notified.
     */
    open var value: T {
        willSet {
            willChangeWithOldValue.raise((value, newValue))
            willChange.raise(value)
        }
        didSet {
            didChangeWithOldValue.raise((oldValue, value))
            didChange.raise(value)
        }
    }

    /**
     Creates and returns an Observable initialized with the provided value.

     */
    public init(_ initialValue: T) {
        value = initialValue
    }

    /**
     Adds a Change Handler to the observable, that is invoked when the value of hte observable changes.

     - parameter target: Target of the handler. The handler will not fire if the target is released.

     - parameter fireImmediately: Flag letting method know whether or not to call the eventHandler immidiately, with the current value of the observable.

     - parameter handler: Closure to be invoked when the value changes.

     - returns: Disposable reference, used to remove the newly added event handler from the event.

     */
    open func addChangeHandler<U: AnyObject>(_ target: U, fireImmediately: Bool = true, handler: @escaping Event<T>.EventHandler) -> Disposable {
        if fireImmediately {
            handler(value)
        }

        return didChange.addHandler(target, handler: handler)
    }
}

/** 
 Objects implimenting this protocol will
 */
protocol Bindable: class {
    associatedtype BoundType
    func boundValueChanged(_ value: BoundType)
}

extension Observable {
    /**
     Binds the value of the observabel to the Bindable, and updates the Bindable when the value changes

     - parameter bound: Object that adheres to the Bindable protocol.

     - returns: Disposable reference, used to remove the newly added event handler from the event.
     */
    func bind<B: Bindable>(_ bound: B) -> Disposable where B.BoundType == T {
        bound.boundValueChanged(value)
        return didChange.addHandler(bound, handler: { [weak bound] value in
            bound?.boundValueChanged(value)
        })
    }

    /**
     Binds the value of the observabel to the Bindable, and updates the Bindable when the value changes

     - parameter bound: Object that adheres to the Bindable protocol.

     - returns: Disposable reference, used to remove the newly added event handler from the event.
     */
    func bind<B: Bindable>(_ bound: B) -> Disposable where B.BoundType == T? {
        bound.boundValueChanged(value)
        return didChange.addHandler(bound, handler: { [weak bound] value in
            bound?.boundValueChanged(value)
        })
    }
}
