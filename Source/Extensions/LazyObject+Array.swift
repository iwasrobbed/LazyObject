//
//  LazyObject+Array.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension LazyObject {

    /**
     Convenience method for instantiating an array of lazy objects

     - parameter array:           An array of JSON dictionaries
     - parameter pruneNullValues: Whether or not to prune keys with null values

     - returns: An array of objects with lazily transformed properties from the underlying dictionaries
     */
    public class func fromArray(array: [NSDictionary], pruneNullValues: Bool = true) -> [LazyObject]? {
        return array.map { self.init(dictionary: $0, pruneNullValues: pruneNullValues) }
    }

}