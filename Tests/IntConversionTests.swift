//
//  IntConversionTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 12/18/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class IntConversionTests: XCTestCase {
    
    class Object: LazyObject {
        var int: Int    { return try! objectFor("int") }
    }
    let object = Object(dictionary: ["int": 42])
    
    func testOriginalValueIsNumber() {
        let value = object.dictionary.value(forKey: "int")
        XCTAssertTrue(value is NSNumber)
    }
    
    func testCachedValueIsNumber() {
        let _ = object.int
        let value = object.dictionary.value(forKey: "int")
        XCTAssertTrue(value is Int)
        XCTAssertTrue(object.int == 42)
    }
    
}
