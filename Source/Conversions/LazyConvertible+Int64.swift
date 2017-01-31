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
        guard let number = value as? NSNumber else {
            throw LazyMappingError.unexpectedTypeError(value: value, type: NSNumber.self)
        }
        
        return number.int64Value
    }
    
}
