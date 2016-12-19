//
//  FloatConversionTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 12/18/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class FloatConversionTests: XCTestCase {
    
    class Object: LazyObject {
        var float: Float    { return try! objectFor("float") }
    }
    let object = Object(dictionary: ["float": 42.42])
    
    func testOriginalValueIsNumber() {
        let value = object.dictionary.value(forKey: "float")
        XCTAssertTrue(value is NSNumber)
    }
    
    func testCachedValueIsNumber() {
        let _ = object.float
        let value = object.dictionary.value(forKey: "float")
        XCTAssertTrue(value is Float)
        XCTAssertTrue(object.float == 42.42)
    }
    
}
