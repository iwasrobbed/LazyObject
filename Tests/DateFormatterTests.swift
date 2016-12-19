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
        XCTAssertTrue(DateFormatter.Lazy.iso8601.toString() == "ISO 8601")
        XCTAssertTrue(DateFormatter.Lazy.rfc3339.toString() == "RFC 3339")
        XCTAssertTrue(DateFormatter.Lazy.rfc1123.toString() == "RFC 1123")
        XCTAssertTrue(DateFormatter.Lazy.rfc850.toString() == "RFC 850")
    }

}
