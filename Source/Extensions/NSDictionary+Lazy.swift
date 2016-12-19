//
//  NSDictionary+Lazy.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

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
