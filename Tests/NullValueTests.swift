//
//  NullValueTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class NullValueTests: XCTestCase {

    class NullObject: LazyObject {
        var nsnull: String?     { return try? objectFor("nsnull") }
        var nullString: String? { return try? objectFor("null_string") }
    }

    let nullObject = NullObject(dictionary: ["nsnull": NSNull(), "null_string": "<null>", "blah": "blerp"])

    func testNSNullValuesRemoved() {
        XCTAssertTrue(nullObject.nsnull == nil)
    }

    func testNullStringValuesRemoved() {
        XCTAssertTrue(nullObject.nullString == nil)
    }

    func testNullKeysPruned() {
        let keys = nullObject.dictionary.allKeys
        XCTAssertTrue(keys.count == 1)
        let key = keys.first as! String
        XCTAssertTrue(key == "blah")
    }

}
