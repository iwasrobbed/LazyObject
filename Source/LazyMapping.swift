//
//  LazyMapping.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

// MARK: - Protocol Interface

public protocol LazyMapping {

    // MARK: - Properties

    /**
     The underlying dictionary, often containing a mixture of JSON (pre-transformations) and objects (`AnyObject`)
     */
    var dictionary: NSMutableDictionary { get set }

    // MARK: - Instantiation

    /**
     Instantiates the class with the given JSON dictionary

     - parameter dictionary:      JSON dictionary
     - parameter pruneNullValues: Whether or not to prune keys with null values

     - returns: An object with lazily transformed properties from the underlying dictionary
     */
    @warn_unused_result
    init(dictionary: NSDictionary, pruneNullValues: Bool)
}

// MARK: - Default Implementation

public extension LazyMapping {

    // MARK: - JSON Types

    /**
     Retrieves a typed object
     
     Optionals: Using `try!` will force it whereas `try?` will safely return `nil` if it failed.

     - parameter getter: The `#function` to get (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object
     */
    @warn_unused_result
    public func objectFor<T>(getter: Selector) throws -> T {
        return try objectFor(NSStringFromSelector(getter))
    }

    /**
     Retrieves a typed object

     - parameter keyPath: The key to get a value for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    @warn_unused_result
    public func objectFor<T>(keyPath: String) throws -> T {
        return try objectForJSONType(keyPath)
    }

    /**
     Retrieves an array of objects

     - parameter getter: The `#function` to get (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    @warn_unused_result
    public func objectFor<T: LazyMapping>(getter: Selector) throws -> [T] {
        return try objectFor(NSStringFromSelector(getter))
    }

    /**
     Retrieves an array of objects

     - parameter keyPath: The key to get a value for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    @warn_unused_result
    public func objectFor<T: LazyMapping>(keyPath: String) throws -> [T] {
        return try arrayForJSONType(keyPath)
    }

    // MARK: - Convertible Types

    /**
     Retrieves an object that conforms to the `LazyConvertible` protocol

     - parameter keyPath: The key to get a value for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object, converted using a `LazyConvertible` method; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    @warn_unused_result
    public func objectFor<T: LazyConvertible where T == T.ConvertedType>(keyPath: String) throws -> T {
        return try objectFor(keyPath, convertWith: T.convert)
    }

}

// MARK: - Private API

private extension LazyMapping {

    // MARK: - JSON Types

    func objectForJSONType<T>(keyPath: String) throws -> T {
        let value = try valueForKeyPath(keyPath)

        // Check if a value for the given type is already stored
        if value is T { return value as! T }

        // Otherwise, try to convert it to the given type
        guard let typedValue = value as? T else {
            throw LazyMappingError.ConversionError(keyPath: keyPath, value: value, type: T.self)
        }

        dictionary.setValue(typedValue as? AnyObject, forKeyPath: keyPath)
        return typedValue
    }

    func arrayForJSONType<T: LazyMapping>(keyPath: String) throws -> [T] {
        let value = try valueForKeyPath(keyPath)
        guard let array = value as? [NSDictionary] else {
            throw LazyMappingError.ConversionError(keyPath: keyPath, value: value, type: [NSDictionary].self)
        }

        let mappedArray = array.map { T(dictionary: $0, pruneNullValues: true) }

        dictionary.setValue(mappedArray as? AnyObject, forKeyPath: keyPath)
        return mappedArray
    }

    // MARK: - Transformations

    func objectFor<T>(keyPath: String, convertWith convert: AnyObject? throws -> T) throws -> T {
        let value = try valueForKeyPath(keyPath)

        // Check if a value for the given type is already stored
        if value is T { return value as! T }

        let transformedValue = try convert(value)
        dictionary.setValue(transformedValue as? AnyObject, forKeyPath: keyPath)
        return transformedValue
    }

    // MARK: - Dictionary Values

    func valueForKeyPath(keyPath: String) throws -> AnyObject {
        guard let value = dictionary.valueForKeyPath(keyPath) else {
            throw LazyMappingError.KeyPathValueNotFoundError(keyPath: keyPath)
        }
        
        return value
    }
    
}