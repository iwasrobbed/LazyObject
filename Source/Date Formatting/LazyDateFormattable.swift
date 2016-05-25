//
//  LazyDateFormattable.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/24/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

// MARK: - ISO 8601

public protocol ISO8601Formattable: LazyDateFormattable {}
extension ISO8601Formattable {
    public func convertToDate(dateString: String) throws -> NSDate {
        return try convertToDate(dateString, formatter: NSDate.LazyFormatter.iso8601)
    }
}

// MARK: - RFC 3339

public protocol RFC3339Formattable: LazyDateFormattable {}
extension RFC3339Formattable {
    public func convertToDate(dateString: String) throws -> NSDate {
        return try convertToDate(dateString, formatter: NSDate.LazyFormatter.rfc3339)
    }
}

// MARK: - RFC 1123

public protocol RFC1123Formattable: LazyDateFormattable {}
extension RFC1123Formattable {
    public func convertToDate(dateString: String) throws -> NSDate {
        return try convertToDate(dateString, formatter: NSDate.LazyFormatter.rfc1123)
    }
}

// MARK: - RFC 850

public protocol RFC850Formattable: LazyDateFormattable {}
extension RFC850Formattable {
    public func convertToDate(dateString: String) throws -> NSDate {
        return try convertToDate(dateString, formatter: NSDate.LazyFormatter.rfc850)
    }
}

// MARK: - Epoch (Unix)

public protocol EpochFormattable: LazyDateFormattable {}
extension EpochFormattable {
    public func convertToDate(epoch: Double) throws -> NSDate {
        return NSDate(timeIntervalSince1970: epoch)
    }
    public func convertToDate(dateString: String) throws -> NSDate {
        guard let epoch = Double(dateString) else {
            throw LazyMappingError.DateConversionError(message: "Could not convert '\(dateString)' into a Double")
        }
        return try convertToDate(epoch)
    }
}

// MARK: - Date Formattable Protocol

public protocol LazyDateFormattable {

    /**
     Retrieves an `NSDate`, transformed based on the type of `LazyDateFormattable` that was used

     - parameter keyPath: The key / key path to get the date for

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate` object, converted using a `LazyDateFormattable` protocol; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    @warn_unused_result
    func dateFor(keyPath: String) throws -> NSDate

    /**
     Retrieves an `NSDate`, transformed based on the type of `LazyDateFormattable` that was used

     - parameter getter: The `#function` to get (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate` object, converted using a `LazyDateFormattable` protocol; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    @warn_unused_result
    func dateFor(getter: Selector) throws -> NSDate

    /**
     Converts the given date time string to an `NSDate` based on the type of formattable used

     - parameter dateString: The date time string to convert

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    @warn_unused_result
    func convertToDate(dateString: String) throws -> NSDate

    /**
     Converts the given epoch time to an `NSDate`

     - parameter epoch: A double representing the epoch time

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    @warn_unused_result
    func convertToDate(epoch: Double) throws -> NSDate

}

// MARK: - Default Implementation 

public extension LazyDateFormattable {

    /**
     Converts the given date time string to an `NSDate` based on the type of formattable used

     - parameter dateString: The date time string to convert

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    @warn_unused_result
    public func convertToDate(dateString: String) throws -> NSDate {
        throw LazyMappingError.CustomError(message: "Must use one of the specialized LazyDateFormattable protocols (e.g. ISO8601Formattable)")
    }

    /**
     Converts the given epoch time to an `NSDate`

     - parameter epoch: A double representing the epoch time

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    @warn_unused_result
    public func convertToDate(epoch: Double) throws -> NSDate {
        throw LazyMappingError.CustomError(message: "Must use the specialized EpochFormattable protocol")
    }

}

// MARK: - Private API

private extension LazyDateFormattable {

    func convertToDate(dateString: String, formatter: NSDate.LazyFormatter) throws -> NSDate {
        let dateFormatter = formatter.toFormatter()
        guard let date = dateFormatter.dateFromString(dateString) else {
            throw LazyMappingError.DateConversionError(message: "Date string ('\(dateString)') could not be formatted using format specification \(formatter.toString())")
        }
        return date
    }

}