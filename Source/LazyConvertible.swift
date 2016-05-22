//
//  LazyConvertible.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

public protocol LazyConvertible {
    associatedtype ConvertedType = Self

    /**
     Converts the given value to a converted type

     - parameter value: The value to convert

     - throws: Either `UnexpectedTypeError` or `CustomError`, based on the implementation details

     - returns: An instance of the converted type
     */
    @warn_unused_result
    static func convert(value: AnyObject?) throws -> ConvertedType
}
