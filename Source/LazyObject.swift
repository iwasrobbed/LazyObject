//
//  LazyObject.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

// MARK: - Public API

public class LazyObject: LazyMapping {

    // MARK: - Properties

    /**
      The underlying dictionary, often containing a mixture of JSON (pre-transformations) and objects (`AnyObject`)
     */
    public var dictionary: NSMutableDictionary

    // MARK: - Instantiation

    /**
     Instantiates the class with the given JSON dictionary

     - parameter dictionary:      JSON dictionary
     - parameter pruneNullValues: Whether or not to prune keys with null values

     - returns: An object with lazily transformed properties from the underlying dictionary
     */
    public required init(dictionary: NSDictionary, pruneNullValues: Bool = true) {
        self.dictionary = NSMutableDictionary(dictionary: pruneNullValues ? dictionary.pruneNullValues() : dictionary)
    }

}