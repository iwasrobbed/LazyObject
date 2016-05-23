//
//  LazyConvertible+NSURL.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/23/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension NSURL: LazyConvertible {

    public static func convert(value: AnyObject?) throws -> NSURL {
        guard let string = value as? String else {
            throw LazyMappingError.UnexpectedTypeError(value: value, type: String.self)
        }

        guard let url = NSURL(string: string) else {
            throw LazyMappingError.CustomError(message: "'\(string)' is not a valid input for NSURL instantiation")
        }

        return url
    }
    
}