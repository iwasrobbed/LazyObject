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
        var boolString1: Bool { return try! objectFor("boolString1") }
        var boolString0: Bool { return try! objectFor("boolString0") }
        var bool1: Bool    { return try! objectFor("bool1") }
        var bool0: Bool    { return try! objectFor("bool0") }
        var boolTrue: Bool  { return try! objectFor("boolTrue") }
        var boolFalse: Bool { return try! objectFor("boolFalse") }
        var boolTrueString: Bool  { return try! objectFor("boolTrueString") }
        var boolFalseString: Bool { return try! objectFor("boolFalseString") }
        var boolYes: Bool  { return try! objectFor("boolYes") }
        var boolNo: Bool { return try! objectFor("boolNo") }
    }
    let object = Object(dictionary: ["boolString1": "1",
                                     "boolString0": "0",
                                     "bool1": 1,
                                     "bool0": 0,
                                     "boolTrue": true,
                                     "boolFalse": false,
                                     "boolTrueString": "true",
                                     "boolFalseString": "false",
                                     "boolYes": "yes",
                                     "boolNo": "no"])
    
    func testOriginalValueIsNumber() {
        let value = object.dictionary.value(forKey: "bool1")
        XCTAssertTrue(value is NSNumber)
    }
    
    func testCachedValueIsNumber() {
        let _ = object.bool1
        let value = object.dictionary.value(forKey: "bool1")
        XCTAssertTrue(value is Bool)
        
        XCTAssertTrue(object.boolString1)
        XCTAssertFalse(object.boolString0)
        XCTAssertTrue(object.bool1)
        XCTAssertFalse(object.bool0)
        XCTAssertTrue(object.boolTrue)
        XCTAssertFalse(object.boolFalse)
        XCTAssertTrue(object.boolTrueString)
        XCTAssertFalse(object.boolFalseString)
        XCTAssertTrue(object.boolYes)
        XCTAssertFalse(object.boolNo)
    }
    
}
