//
//  ErrorTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/21/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class ErrorTests: XCTestCase {

    func testKeyPathValueNotFoundError() {
        class Object: LazyObject {
            var missingKey: String? { return try? objectFor("missing_key") }
        }

        let object = Object(dictionary: [:])
        do {
            let _: String = try object.objectFor("missing_key")
            XCTFail()
        } catch LazyMappingError.keyPathValueNotFoundError(_) {
            XCTAssertNil(object.missingKey)
        } catch let e {
            XCTFail("Test failed for an unexpected reason: \(e)")
        }
    }

    /**
     Essentially, test a scenario where a custom convertible wasn't created yet
     */
    func testConversionError() {
        class Object: LazyObject {
            var badType: URLRequest? { return try? objectFor("key") }
        }

        let object = Object(dictionary: ["key": 42])
        do {
            let _: URLRequest = try object.objectFor("key")
            XCTFail()
        } catch LazyMappingError.conversionError(_, _, _) {
            XCTAssertNil(object.badType)
        } catch let e {
            XCTFail("Test failed for an unexpected reason: \(e)")
        }
    }

    func testUnexpectedTypeError() {
        class Object: LazyObject {
            var badType: NSNumber? { return try? objectFor("number_from_string") }
        }

        // NSNumber expects string (representing a number) or number inputs
        let object = Object(dictionary: ["number_from_string": ["blah": "blerp"]])
        do {
            let _: NSNumber = try object.objectFor("number_from_string")
            XCTFail()
        } catch LazyMappingError.unexpectedTypeError(_, _) {
            XCTAssertNil(object.badType)
        } catch let e {
            XCTFail("Test failed for an unexpected reason: \(e)")
        }
    }

    func testCustomError() {
        class Object: LazyObject {
            var badNumberValue: NSNumber? { return try? objectFor("number_from_string") }
        }

        // NSNumber expects string (representing a number) or number inputs
        let object = Object(dictionary: ["number_from_string": "this is not a number"])
        do {
            let _: NSNumber = try object.objectFor("number_from_string")
            XCTFail()
        } catch LazyMappingError.customError(_) {
            XCTAssertNil(object.badNumberValue)
        } catch let e {
            XCTFail("Test failed for an unexpected reason: \(e)")
        }
    }

}
