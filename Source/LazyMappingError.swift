//
//  LazyMappingError.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

public enum LazyMappingError: ErrorType {
    /**
      Thrown when a value is not found for the given key path
     */
    case KeyPathValueNotFoundError(keyPath: String)

    /**
      Thrown when a value cannot be casted to the expected type
     */
    case ConversionError(keyPath: String, value: AnyObject, type: Any.Type)

    /**
      Thrown when a value to convert is not the type that was expected
     */
    case UnexpectedTypeError(value: AnyObject?, type: Any.Type)

    /**
      Typically thrown during conversions/transformations
     */
    case CustomError(message: String)
}