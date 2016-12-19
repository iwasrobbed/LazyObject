//
//  LazyConvertible+NSURL.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/23/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension URL: LazyConvertible {

    public static func convert(_ value: Any?) throws -> URL {
        guard let string = value as? String else {
            throw LazyMappingError.unexpectedTypeError(value: value, type: String.self)
        }

        guard let url = URL(string: string) else {
            throw LazyMappingError.customError(message: "'\(string)' is not a valid input for NSURL instantiation")
        }

        return url
    }
    
}
