//
//  LazyValueTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class LazyValueTests: XCTestCase {

    class Object: LazyObject {
        var otherObjects: [OtherObject] { return try! objectFor("other_objects") }
    }
    class OtherObject: LazyObject {
        var name: String    { return try! objectFor("name") }
    }
    static let otherObjects = [["name": "Bill"], ["name": "Jane"]]
    let object = Object(dictionary: ["other_objects": otherObjects])

    func testOriginalValuesAreAny() {
        let value = object.dictionary.value(forKey: "other_objects")
        XCTAssertTrue(value is [Any])
    }

    func testCachedValuesAreTypedObject() {
        let _ = object.otherObjects
        let value = object.dictionary.value(forKey: "other_objects")
        XCTAssertTrue(value is [OtherObject])
    }

}
