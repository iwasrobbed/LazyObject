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
    public func convertToDate(_ dateString: String) throws -> Date {
        return try convertToDate(dateString, formatter: DateFormatter.Lazy.iso8601)
    }
}

// MARK: - RFC 3339

public protocol RFC3339Formattable: LazyDateFormattable {}
extension RFC3339Formattable {
    public func convertToDate(_ dateString: String) throws -> Date {
        return try convertToDate(dateString, formatter: DateFormatter.Lazy.rfc3339)
    }
}

// MARK: - RFC 1123

public protocol RFC1123Formattable: LazyDateFormattable {}
extension RFC1123Formattable {
    public func convertToDate(_ dateString: String) throws -> Date {
        return try convertToDate(dateString, formatter: DateFormatter.Lazy.rfc1123)
    }
}

// MARK: - RFC 850

public protocol RFC850Formattable: LazyDateFormattable {}
extension RFC850Formattable {
    public func convertToDate(_ dateString: String) throws -> Date {
        return try convertToDate(dateString, formatter: DateFormatter.Lazy.rfc850)
    }
}

// MARK: - Epoch (Unix)

public protocol EpochFormattable: LazyDateFormattable {}
extension EpochFormattable {
    public func convertToDate(_ epoch: Double) throws -> Date {
        return Date(timeIntervalSince1970: epoch)
    }
    public func convertToDate(_ dateString: String) throws -> Date {
        guard let epoch = Double(dateString) else {
            throw LazyMappingError.dateConversionError(message: "Could not convert '\(dateString)' into a Double")
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
    
    func dateFor(_ keyPath: String) throws -> Date

    /**
     Retrieves an `NSDate`, transformed based on the type of `LazyDateFormattable` that was used

     - parameter getter: The `#function` to get (e.g. for a property named `name`, specifying #function will convert it to a string of `name`)

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate` object, converted using a `LazyDateFormattable` protocol; using `try!` will force it whereas `try?` will safely return `nil` if it failed.
     */
    
    func dateFor(_ getter: Selector) throws -> Date

    /**
     Converts the given date time string to an `NSDate` based on the type of formattable used

     - parameter dateString: The date time string to convert

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    
    func convertToDate(_ dateString: String) throws -> Date

    /**
     Converts the given epoch time to an `NSDate`

     - parameter epoch: A double representing the epoch time

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    
    func convertToDate(_ epoch: Double) throws -> Date

}

// MARK: - Default Implementation 

public extension LazyDateFormattable {

    /**
     Converts the given date time string to an `NSDate` based on the type of formattable used

     - parameter dateString: The date time string to convert

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    
    public func convertToDate(_ dateString: String) throws -> Date {
        throw LazyMappingError.customError(message: "Must use one of the specialized LazyDateFormattable protocols (e.g. ISO8601Formattable)")
    }

    /**
     Converts the given epoch time to an `NSDate`

     - parameter epoch: A double representing the epoch time

     - throws: A `LazyMappingError` depending on the circumstances

     - returns: An `NSDate`
     */
    
    public func convertToDate(_ epoch: Double) throws -> Date {
        throw LazyMappingError.customError(message: "Must use the specialized EpochFormattable protocol")
    }

}

// MARK: - Private API

private extension LazyDateFormattable {

    func convertToDate(_ dateString: String, formatter: DateFormatter.Lazy) throws -> Date {
        let dateFormatter = formatter.toFormatter()
        guard let date = dateFormatter.date(from: dateString) else {
            throw LazyMappingError.dateConversionError(message: "Date string ('\(dateString)') could not be formatted using format specification \(formatter.toString())")
        }
        return date
    }

}
