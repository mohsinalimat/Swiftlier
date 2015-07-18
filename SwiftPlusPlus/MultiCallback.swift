//
//  MultiCallback.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 1/5/15.
//  Copyright (c) 2015 Drewag LLC. All rights reserved.
//

import Foundation

/**
    Object that allows the registration of multiple callbacks
*/
public final class MultiCallback<CallbackArguments> {
    typealias CallBackType = (CallbackArguments) -> ()
    
    // MARK: Properties
    
    private var observers: [(observer: WeakWrapper, callbacks: [CallBackType])] = []
    
    // MARK: Initializers
    
    public init() {}
    
    // MARK: Methods
    
    /**
        Add a callback for when object is triggered
    
        :param: observer observing object to be referenced later to remove the hundler
        :param: callback callback to be called
    */
    public func addObserver(observer: AnyObject, callback: CallBackType) {
        if let index = self.indexOfObserver(observer) {
            // since the observer exists, add the callback to the existing array
            self.observers[index].callbacks.append(callback)
        }
        else {
            // since the observer does not already exist, add a new tuple with the
            // observer and an array with the callback
            self.observers.append(observer: WeakWrapper(observer), callbacks: [callback])
        }
    }
    
    /**
        Remove a callback for when object is triggered
    
        :param: observer observing object passed in when registering the callback originally
    */
    public func removeObserver(observer: AnyObject) {
        if let index = self.indexOfObserver(observer) {
            self.observers.removeAtIndex(index)
        }
    }
    
    /**
        Trigger registered callbacks to be called with the given arguments
    
        Callbacks are all executed on the same thread before this method returns
    
        :param: arguments the arguments to trigger the callbacks with
    */
    public func triggerWithArguments(arguments: CallbackArguments) {
        for (observer, callbacks) in self.observers {
            if observer.value != nil {
                for callback in callbacks {
                    callback(arguments)
                }
            }
            else {
                if let index = self.indexOfObserver(observer) {
                    self.observers.removeAtIndex(index)
                }
            }
        }
    }
}

// MARK - Private Methods

private extension MultiCallback {
    func indexOfObserver(observer: AnyObject) -> Int? {
        var index: Int = 0
        for (possibleObserver, callbacks) in self.observers {
            if possibleObserver.value === observer {
                return index
            }
            index++
        }
        return nil
    }
}