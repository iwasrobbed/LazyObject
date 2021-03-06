//
//  LazyConvertible+Bool.swift
//  LazyObject
//
//  Created by Rob Phillips on 12/18/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension Bool: LazyConvertible {
    
    public static func convert(_ value: Any?) throws -> Bool {
        if let number = value as? NSNumber {
            return number.boolValue
        } else if let boolString = value as? String, let bool = Bool(boolString) {
            return bool
        }
        
        throw LazyMappingError.unexpectedTypeError(value: value, type: NSNumber.self)
    }
    
}
