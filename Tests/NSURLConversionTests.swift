//
//  NSURLConversionTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/23/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class NSURLConversionTests: XCTestCase {

    class Object: LazyObject {
        var url: NSURL   { return try! objectFor("url") }
    }
    static let absoluteString = "http://i.giphy.com/3o7qE8co3YAzNUoAW4.gif"
    let object = Object(dictionary: ["url": absoluteString])

    func testOriginalValueIsString() {
        let value = object.dictionary.valueForKey("url")
        XCTAssertTrue(value is String)
    }

    func testCachedValueIsSameURL() {
        let url = object.url
        let value = object.dictionary.valueForKey("url")
        XCTAssertTrue(value is NSURL)
        XCTAssertTrue(url.absoluteString == NSURLConversionTests.absoluteString)
    }
    
}