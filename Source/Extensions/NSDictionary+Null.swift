//
//  NSDictionary+Null.swift
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
    func pruneNullValues() -> NSDictionary {
        let nonNullDictionary = self.mutableCopy() as! NSMutableDictionary
        let keysForNullValues = nonNullDictionary.allKeysForObject(NSNull())
        let keysForNullStringValues = nonNullDictionary.allKeysForObject("<null>")
        nonNullDictionary.removeObjectsForKeys(keysForNullValues)
        nonNullDictionary.removeObjectsForKeys(keysForNullStringValues)
        return nonNullDictionary
    }

}