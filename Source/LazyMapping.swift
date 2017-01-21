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
     The underlying dictionary, often containing a mixture of JSON (pre-transformations) and objects (`Any`)
     */
    var dictionary: NSMutableDictionary { get set }

    // MARK: - Instantiation

    /**
     Instantiates the class with the given JSON dictionary

     - parameter dictionary:      JSON dictionary
     - parameter pruneNullValues: Whether or not to prune keys with null values

     - returns: An object with lazily transformed properties from the underlying dictionary
     */
    
    init(dictionary: NSDictionary, pruneNullValues: Bool)
}

// MARK: - Default Getter Implementations

public extension LazyMapping {

    // MARK: - Generic JSON Types

    /**
     Retrieves a typed object
     
     Optionals: Using `try!` will force it whereas `try?` will safely return `nil` if it failed.

     - parameter getter: The `#function` to get (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object
     */
    
    public func objectFor<T>(_ getter: Selector) throws -> T {
        return try objectFor(NSStringFromSelector(getter))
    }

    /**
     Retrieves a typed object

     - parameter keyPath: The key / key path to get a value for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    
    public func objectFor<T>(_ keyPath: String) throws -> T {
        return try objectForJSONType(keyPath)
    }

    /**
     Retrieves an array of objects

     - parameter getter: The `#function` to get (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    
    public func objectFor<T: LazyMapping>(_ getter: Selector) throws -> [T] {
        return try objectFor(NSStringFromSelector(getter))
    }

    /**
     Retrieves an array of objects

     - parameter keyPath: The key / key path to get a value for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    
    public func objectFor<T: LazyMapping>(_ keyPath: String) throws -> [T] {
        return try arrayForJSONType(keyPath)
    }

    // MARK: - Convertible Types

    /**
     Retrieves an object that conforms to the `LazyConvertible` protocol

     - parameter keyPath: The key / key path to get a value for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: A typed object, converted using a `LazyConvertible` method; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    
    public func objectFor<T: LazyConvertible>(_ keyPath: String) throws -> T where T == T.ConvertedType {
        return try objectFor(keyPath, convertWith: T.convert)
    }

}

// MARK: - Date Types

public extension LazyMapping where Self: LazyDateFormattable {

    /**
     Retrieves an `NSDate`, transformed based on the type of `LazyDateFormattable` that was used

     - parameter getter: The `#function` to get (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate` object, converted using a `LazyDateFormattable` protocol; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    
    public func dateFor(_ getter: Selector) throws -> Date {
        return try dateFor(NSStringFromSelector(getter))
    }

    /**
     Retrieves an `NSDate`, transformed based on the type of `LazyDateFormattable` that was used

     - parameter keyPath: The key / key path to get the date for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate` object, converted using a `LazyDateFormattable` protocol; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    
    public func dateFor(_ keyPath: String) throws -> Date {
        let dateValue: Any = try objectFor(keyPath)
        if dateValue is Double {
            return try convertToDate(dateValue as! Double)
        }
        return try convertToDate(dateValue as! String)
    }

}

// MARK: - Default Setter Implementations

public extension LazyMapping {

    /**
     Sets the object for the given setter selector

     - parameter setter: The `#function` to set (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)
     */
    public func setObject(_ object: Any?, setter: Selector) {
        setObject(object, keyPath: NSStringFromSelector(setter))
    }

    /**
     Sets the object for the given key / key path

     - parameter keyPath: The key / key path to set the value for
     */
    public func setObject(_ object: Any?, keyPath: String) {
        if let object = object {
            dictionary.setObject(object, forKey: keyPath as NSCopying)
        } else {
            dictionary.removeObject(forKey: keyPath)
        }
    }

}

// MARK: - Private API

private extension LazyMapping {

    // MARK: - Generic JSON Types

    func objectForJSONType<T>(_ keyPath: String) throws -> T {
        let value = try valueForKeyPath(keyPath)
        
        // Check if a value for the given type is already stored
        if value is T { return value as! T }
        
        // Otherwise, try to convert it to the given type
        guard let typedValue = value as? T else {
            throw LazyMappingError.conversionError(keyPath: keyPath, value: value, type: T.self)
        }

        dictionary.setValue(typedValue, forKeyPath: keyPath)
        return typedValue
    }

    func arrayForJSONType<T: LazyMapping>(_ keyPath: String) throws -> [T] {
        let value = try valueForKeyPath(keyPath)
        
        // Check if a value for the given type is already stored
        if value is [T] { return value as! [T] }
        
        // Otherwise, try to convert it to the given type
        guard let array = value as? [NSDictionary] else {
            throw LazyMappingError.conversionError(keyPath: keyPath, value: value, type: [NSDictionary].self)
        }

        let mappedArray = array.map { T(dictionary: $0, pruneNullValues: true) }

        dictionary.setValue(mappedArray, forKeyPath: keyPath)
        return mappedArray
    }

    // MARK: - Transformations

    func objectFor<T>(_ keyPath: String, convertWith convert: (Any?) throws -> T) throws -> T {
        let value = try valueForKeyPath(keyPath)

        // Check if a value for the given type is already stored
        if value is T { return value as! T }

        // Otherwise, try to convert it to the given type
        let transformedValue = try convert(value)
        dictionary.setValue(transformedValue, forKeyPath: keyPath)
        return transformedValue
    }

    // MARK: - Dictionary Values

    func valueForKeyPath(_ keyPath: String) throws -> Any {
        guard let value = dictionary.lazyValue(forKeyPath: keyPath) else {
            throw LazyMappingError.keyPathValueNotFoundError(keyPath: keyPath)
        }
        
        return value as Any
    }
    
}
