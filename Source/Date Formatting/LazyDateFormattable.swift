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

// MARK: - Date Formattable Protocol

public protocol LazyDateFormattable {

    @warn_unused_result
    func dateFor(keyPath: String) throws -> NSDate

    @warn_unused_result
    func dateFor(getter: Selector) throws -> NSDate

    @warn_unused_result
    func convertToDate(dateString: String) throws -> NSDate

}

// MARK: - Default Implementation 

public extension LazyDateFormattable {

    @warn_unused_result
    public func convertToDate(dateString: String) throws -> NSDate {
        fatalError("Must use one of the specialized LazyDateFormattable protocols (e.g. ISO8601Formattable)")
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