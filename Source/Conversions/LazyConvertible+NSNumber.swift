//
//  LazyConvertible+NSNumber.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension NSNumber: LazyConvertible {

    public static func convert(_ value: Any?) throws -> NSNumber {
        guard let string = value as? String else {
            throw LazyMappingError.unexpectedTypeError(value: value, type: String.self)
        }

        let formatter = NumberFormatter()
        guard let number = formatter.number(from: string) else {
            throw LazyMappingError.customError(message: "'\(string)' is not a valid input for NSNumber instantiation")
        }

        return number
    }

}
