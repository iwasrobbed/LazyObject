//
//  LazyConvertible+Double.swift
//  LazyObject
//
//  Created by Rob Phillips on 12/18/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension Double: LazyConvertible {
    
    public static func convert(_ value: Any?) throws -> Double {
        guard let number = value as? NSNumber else {
            throw LazyMappingError.unexpectedTypeError(value: value, type: NSNumber.self)
        }
        
        return number.doubleValue
    }
    
}
