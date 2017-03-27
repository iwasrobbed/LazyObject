//
//  NSDictionary+Lazy.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

// MARK: - Pruning

extension NSDictionary {

    /**
     Prunes keys that have null values from the dictionary.

     - returns: A pruned dictionary
     */
    public func pruneNullValues() -> NSDictionary {
        let nonNullDictionary = self.mutableCopy() as! NSMutableDictionary
        let keysForNullValues = nonNullDictionary.allKeys(for: NSNull())
        let keysForNullStringValues = nonNullDictionary.allKeys(for: "<null>")
        nonNullDictionary.removeObjects(forKeys: keysForNullValues)
        nonNullDictionary.removeObjects(forKeys: keysForNullStringValues)
        return nonNullDictionary
    }
    
}

// MARK: - KVO Safety

extension NSDictionary {
    
    /**
     Safely returns a value at the given key / key path if it exists
     
     - returns: A value of type `Any?`
     */
    func lazyValue(forKeyPath keyPath: String) -> Any? {
        var object: Any? = self
        var keys = keyPath.characters.split(separator: ".").map(String.init)
        
        while keys.count > 0, let currentObject = object {
            let key = keys.remove(at: 0)
            object = (currentObject as? NSDictionary)?[key]
        }
        return object
    }
    
}

extension NSMutableDictionary {
    
    /// Safely sets a value for a given key path, making existing nodes mutable if necessary
    ///
    /// - Parameters:
    ///   - value: The value to set
    ///   - keyPath: The key path to use
    func lazySet(value: Any?, forKeyPath keyPath: String) {
        _makeDirectoriesMutable(forKeyPath: keyPath)
        setValue(value, forKeyPath: keyPath)
    }
    
    /// Recursively traverses the given key path and turns any `NSDictionary` objects it finds into `NSMutableDictionary` equivalents so we can write back to the key path
    ///
    /// - Parameter keyPath: The key path to search
    fileprivate func _makeDirectoriesMutable(forKeyPath keyPath: String) {
        let keys = keyPath.characters.split(separator: ".").map(String.init)
        var currentKeyPath: String?
        
        keys.forEach { key in
            if currentKeyPath != nil {
                let nextKeyPathAddition = String(format: ".%@", key)
                currentKeyPath = currentKeyPath?.appending(nextKeyPathAddition)
            } else {
                currentKeyPath = key
            }
            
            if let currentKeyPath = currentKeyPath, let value = lazyValue(forKeyPath: currentKeyPath) as? NSDictionary {
                setValue(value.mutableCopy(), forKeyPath: currentKeyPath)
            }
        }
        
    }
    
}
