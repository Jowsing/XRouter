//
//  SafeDictionary.swift
//  XRouter
//
//  Created by jowsing on 2024/12/8.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public final class SafeDictionary<Key: Hashable, Value> {
    
    private var dictionary = [Key: Value]()
    
    private let lock = UnfairLock()
    
    public subscript(key: Key) -> Value? {
        get {
            self.lock.lock(); defer { self.lock.unlock() }
            return self.dictionary[key]
        }
        set {
            self.lock.lock()
            self.dictionary[key] = newValue
            self.lock.unlock()
        }
    }
    
    public func removeValue(forKey key: Key) -> Value? {
        self.lock.lock(); defer { self.lock.unlock() }
        return self.dictionary.removeValue(forKey: key)
    }
}

final class UnfairLock {
    
    private let unfairLock: os_unfair_lock_t

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    fileprivate func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    fileprivate func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}
