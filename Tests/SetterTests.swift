//
//  SetterTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/23/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class SetterTests: XCTestCase {

    class Object: LazyObject {
        var id: NSNumber? {
            get {
                return try? objectFor(#function)
            }
            set {
                setObject(newValue, setter: #function)
            }
        }
        var nestedId: NSNumber? {
            get {
                return try? objectFor("nested.identifier")
            }
            set {
                setObject(newValue, keyPath: "nested.identifier")
            }
        }
    }
    
    let object = Object(dictionary: ["id": "42",
                                     "nested": ["identifier": "24"]])

    func testSettingObjectByKeyPath() {
        XCTAssertTrue(object.id != 43)
        object.setObject(43, keyPath: "id")
        XCTAssertTrue(object.id == 43)
        
        XCTAssertTrue(object.nestedId != 43)
        object.nestedId = 43
        XCTAssertTrue(object.nestedId == 43)
    }

    func testSettingObjectBySetter() {
        XCTAssertTrue(object.id != 44)
        object.id = 44
        XCTAssertTrue(object.id == 44)
    }

    func testRemovingObjectUsingNilValueForNonNestedSetter() {
        // Non-nested type
        object.id = 24
        XCTAssertTrue(object.id == 24)

        object.id = nil
        XCTAssertNil(object.id)
    }
    
    func testRemovingObjectUsingNilValueForNestedSetter() {
        // Nested type
        object.nestedId = 42
        XCTAssertTrue(object.nestedId == 42)
        
        object.nestedId = nil
        XCTAssertNil(object.nestedId)
    }

}
