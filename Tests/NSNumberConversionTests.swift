//
//  ConversionTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class NSNumberConversionTests: XCTestCase {

    class Object: LazyObject {
        var number: NSNumber    { return try! objectFor("number") }
    }
    let object = Object(dictionary: ["number": "42"])

    func testOriginalValueIsString() {
        let value = object.dictionary.value(forKey: "number")
        XCTAssertTrue(value is String)
    }

    func testCachedValueIsNumber() {
        let _ = object.number
        let value = object.dictionary.value(forKey: "number")
        XCTAssertTrue(value is NSNumber)
    }

}
