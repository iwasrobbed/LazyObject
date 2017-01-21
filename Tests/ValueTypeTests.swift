//
//  ValueTypeTests.swift
//  LazyObjectTests
//
//  Created by Rob Phillips on 5/20/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class ValueTypeTests: XCTestCase {

    func testBoolValues() {
        class BoolObject: LazyObject {
            var lifeIsGreat: Bool       { return try! objectFor("life_is_great") }
            var lifeIsSwell: Bool       { return try! objectFor("life_is_swell") }
            var lifeSucks: Bool         { return try! objectFor("life_sucks") }
            var lifeIsNotSwell: Bool    { return try! objectFor("life_is_not_swell") }
        }

        let boolObject = BoolObject(dictionary: ["life_is_great": true, "life_is_swell": 1,
                                                 "life_sucks": false, "life_is_not_swell": 0])
        XCTAssertTrue(boolObject.lifeIsGreat)
        XCTAssertTrue(boolObject.lifeIsSwell)
        XCTAssertFalse(boolObject.lifeSucks)
        XCTAssertFalse(boolObject.lifeIsNotSwell)
    }

    func testOptionalOrMissingKeyValues() {
        class OptionalObject: LazyObject {
            var money: Double?  { return try? objectFor("money") }
            var getPaid: Bool?  { return try? objectFor("get_paid") }
            var missingKey: String? { return try? objectFor("missing_key") }
        }

        let optionalObject = OptionalObject(dictionary: ["money": NSNull(), "get_paid": true])
        XCTAssertNil(optionalObject.money)
        XCTAssertTrue(optionalObject.getPaid!)
        XCTAssertNil(optionalObject.missingKey)
    }
    
    func testStringValues() {
        class StringObject: LazyObject {
            var name: String    { return try! objectFor("name") }
        }

        let stringObject = StringObject(dictionary: ["name": "String McStringface"])
        XCTAssertTrue(stringObject.name == "String McStringface")
    }

    func testIntegerValues() {
        class IntegerObject: LazyObject {
            var answerToLife: Int   { return try! objectFor("answer_to_life") }
        }

        let integerObject = IntegerObject(dictionary: ["answer_to_life": 42])
        XCTAssertTrue(integerObject.answerToLife == 42)
    }

    func testFloatingPointValues() {
        class FloatingPointObject: LazyObject {
            var answerToLife: Float { return try! objectFor("answer_to_life") }
        }

        let floatingPointObject = FloatingPointObject(dictionary: ["answer_to_life": 42.42])
        XCTAssertTrue(floatingPointObject.answerToLife == 42.42)
    }

    func testExponentialValues() {
        class ExponentialObject: LazyObject {
            var answerToLife: Float { return try! objectFor("answer_to_life") }
        }

        let exponentialObject = ExponentialObject(dictionary: ["answer_to_life": 42e-002])
        XCTAssertTrue(exponentialObject.answerToLife == 0.42)
    }

    func testArrayKeyValues() {
        class ArrayObject: LazyObject {
            var answersToLife: [Int]    { return try! objectFor("answers_to_life") }
        }

        let arrayObject = ArrayObject(dictionary: ["answers_to_life": [42, 42, 42]])
        XCTAssertTrue(arrayObject.answersToLife == [42, 42, 42])
    }

    func testArrayFunctionValues() {
        class ArrayObject: LazyObject {
            var answers: [Int]  { return try! objectFor(#function) }
        }

        let arrayObject = ArrayObject(dictionary: ["answers": [42, 42, 42]])
        XCTAssertTrue(arrayObject.answers == [42, 42, 42])
        
        // Need to also test that fetching it a second time 
        // will use the cached value instead of converting from dictionary
        arrayObject.answers.forEach { XCTAssertTrue($0 == 42) }
    }
    
    func testArrayOfLazyObjectValues() {
        class ArrayParentObject: LazyObject {
            var items: [ItemObject]  { return try! objectFor(#function) }
        }
        class ItemObject: LazyObject {
            var number: Int { return try! objectFor(#function) }
        }
        
        let itemObjectDictionaries = [["number": 42], ["number": 24]]
        let arrayParentObject = ArrayParentObject(dictionary: ["items": itemObjectDictionaries])
        XCTAssertTrue(arrayParentObject.items.first?.number == 42)
        
        // Need to also test that fetching it a second time
        // will use the cached value instead of converting from dictionary
        XCTAssertTrue(arrayParentObject.items.last?.number == 24)
    }

    func testDictionaryValues() {
        class DictionaryObject: LazyObject {
            var answersToLife: NSDictionary { return try! objectFor("answers_to_life") }
        }

        let dictionaryObject = DictionaryObject(dictionary: ["answers_to_life": ["first_answer": 42]])
        let answer = dictionaryObject.answersToLife["first_answer"] as! Int
        XCTAssertTrue(answer == 42)
    }

    func testKeyPathValues() {
        class KeyPathObject: LazyObject {
            var answerToLife: Int { return try! objectFor("answers_to_life.look_deep.look_deeper") }
        }

        let keyPathObject = KeyPathObject(dictionary: ["answers_to_life": ["look_deep": ["look_deeper": 42]]])
        XCTAssertTrue(keyPathObject.answerToLife == 42)
    }
    
}
