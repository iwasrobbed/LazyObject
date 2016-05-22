//
//  LazyConvertible+NSNumber.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension NSNumber: LazyConvertible {

    public static func convert(value: AnyObject?) throws -> NSNumber {
        guard let string = value as? String else {
            throw LazyMappingError.UnexpectedTypeError(value: value, type: String.self)
        }

        let formatter = NSNumberFormatter()
        guard let number = formatter.numberFromString(string) else {
            throw LazyMappingError.CustomError(message: "'\(string)' is not a valid input for NSNumber instantiation")
        }

        return number
    }

}
