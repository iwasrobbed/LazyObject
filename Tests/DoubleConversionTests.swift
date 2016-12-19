//
//  DoubleConversionTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 12/18/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class doubleConversionTests: XCTestCase {
    
    class Object: LazyObject {
        var double: Double    { return try! objectFor("double") }
    }
    let object = Object(dictionary: ["double": 42.42])
    
    func testOriginalValueIsNumber() {
        let value = object.dictionary.value(forKey: "double")
        XCTAssertTrue(value is NSNumber)
    }
    
    func testCachedValueIsNumber() {
        let _ = object.double
        let value = object.dictionary.value(forKey: "double")
        XCTAssertTrue(value is Double)
        XCTAssertTrue(object.double == 42.42)
    }
    
}
