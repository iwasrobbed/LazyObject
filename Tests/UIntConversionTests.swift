//
//  UIntConversionTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 12/18/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class UIntConversionTests: XCTestCase {
    
    class Object: LazyObject {
        var uint: UInt    { return try! objectFor("uint") }
    }
    let object = Object(dictionary: ["uint": 42])
    
    func testOriginalValueIsNumber() {
        let value = object.dictionary.value(forKey: "uint")
        XCTAssertTrue(value is NSNumber)
    }
    
    func testCachedValueIsNumber() {
        let _ = object.uint
        let value = object.dictionary.value(forKey: "uint")
        XCTAssertTrue(value is UInt)
        XCTAssertTrue(object.uint == 42)
    }
    
}
