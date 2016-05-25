//
//  DateFormatterTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/25/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

import XCTest
@testable import LazyObject

final class DateFormatterTests: XCTestCase {

    func testFormatterToString() {
        XCTAssertTrue(NSDate.LazyFormatter.iso8601.toString() == "ISO 8601")
        XCTAssertTrue(NSDate.LazyFormatter.rfc3339.toString() == "RFC 3339")
        XCTAssertTrue(NSDate.LazyFormatter.rfc1123.toString() == "RFC 1123")
        XCTAssertTrue(NSDate.LazyFormatter.rfc850.toString() == "RFC 850")
    }

}