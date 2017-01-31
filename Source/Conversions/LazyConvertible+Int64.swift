//
//  LazyConvertible+Int64.swift
//  LazyObject
//
//  Created by Rob Phillips on 1/30/17.
//  Copyright © 2017 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension Int64: LazyConvertible {
    
    public static func convert(_ value: Any?) throws -> Int64 {
        if let number = value as? NSNumber {
            return number.int64Value
        } else if let numberString = value as? String, let bigInt = Int64(numberString) {
            return bigInt
        }
        
        throw LazyMappingError.unexpectedTypeError(value: value, type: NSNumber.self)
    }
    
}
