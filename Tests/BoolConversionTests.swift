//
//  BoolConversionTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 12/18/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class boolConversionTests: XCTestCase {
    
    class Object: LazyObject {
        var bool1: Bool    { return try! objectFor("bool1") }
        var bool0: Bool    { return try! objectFor("bool0") }
        var boolTrue: Bool  { return try! objectFor("boolTrue") }
        var boolFalse: Bool { return try! objectFor("boolFalse") }
    }
    let object = Object(dictionary: ["bool1": 1,
                                     "bool0": 0,
                                     "boolTrue": true,
                                     "boolFalse": false])
    
    func testOriginalValueIsNumber() {
        let value = object.dictionary.value(forKey: "bool1")
        XCTAssertTrue(value is NSNumber)
    }
    
    func testCachedValueIsNumber() {
        let _ = object.bool1
        let value = object.dictionary.value(forKey: "bool1")
        XCTAssertTrue(value is Bool)
        
        XCTAssertTrue(object.bool1)
        XCTAssertFalse(object.bool0)
        XCTAssertTrue(object.boolTrue)
        XCTAssertFalse(object.boolFalse)
    }
    
}
