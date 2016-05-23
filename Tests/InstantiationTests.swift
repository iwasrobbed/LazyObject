//
//  InstantiationTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class InstantiationTests: XCTestCase {

    func testInstantiatingWithEmptyDictionary() {
        class Object: LazyObject {}

        // An empty dictionary is still valid, but likely stems from a server issue
        let object = Object(dictionary: [:])
        XCTAssertNotNil(object)
    }

    func testInstantiatingWithPopulatedDictionary() {
        class Object: LazyObject {
            var hai: String { return try! objectFor(#function) }
        }

        let object = Object(dictionary: ["hai": "there"])
        XCTAssertTrue(object.hai == "there")
    }

    func testInstantiatingWithArray() {
        class Object: LazyObject {
            var blah: String { return try! objectFor(#function) }
        }

        guard let objects = Object.fromArray([["hai": "there"], ["my": "name"], ["is": "Hank"]]) as? [Object] else {
            XCTFail("Could not instantiate the array of objects. I have failed you and I'm sorry :(")
            return
        }

        XCTAssertTrue(objects.count == 3)
    }

}
