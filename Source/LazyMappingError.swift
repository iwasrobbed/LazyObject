//
//  LazyMappingError.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

public enum LazyMappingError: Error {
    /**
      Thrown when a value is not found for the given key path
     */
    case keyPathValueNotFoundError(keyPath: String)

    /**
      Thrown when a value cannot be casted to the expected type
     */
    case conversionError(keyPath: String?, value: Any, type: Any.Type)

    /**
      Thrown when a value to convert is not the type that was expected
     */
    case unexpectedTypeError(value: Any?, type: Any.Type)

    /**
      Thrown when a date string could not be properly transformed into an `NSDate`
     */
    case dateConversionError(message: String)

    /**
      Typically thrown during conversions/transformations
     */
    case customError(message: String)
}
