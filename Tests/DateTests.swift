//
//  DateTests.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/24/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import XCTest
@testable import LazyObject

final class DateTests: XCTestCase {

    func testValidISO8601() {
        class Object: LazyObject, ISO8601Formattable {
            var date: NSDate?   { return try? dateFor(#function) }
        }

        let object = Object(dictionary: ["date": "2016-04-24T14:42:42.424Z"])
        guard let date = object.date else {
            XCTFail("Formatter failed to parse string.")
            return
        }
        XCTAssertTrue(date.dateMatches(millisecond: 424))
    }

    func testValidRFC3339() {
        class Object: LazyObject, RFC3339Formattable {
            var date: NSDate?   { return try? dateFor(#function) }
        }

        let object = Object(dictionary: ["date": "2016-04-24T14:42:42Z"])
        guard let date = object.date else {
            XCTFail("Formatter failed to parse string.")
            return
        }
        XCTAssertTrue(date.dateMatches())
    }

    func testValidRFC1123() {
        class Object: LazyObject, RFC1123Formattable {
            var date: NSDate?   { return try? dateFor(#function) }
        }

        let object = Object(dictionary: ["date": "Sun, 24 Apr 2016 14:42:42 +0000"])
        guard let date = object.date else {
            XCTFail("Formatter failed to parse string.")
            return
        }
        XCTAssertTrue(date.dateMatches())
    }

    func testValidRFC850() {
        class Object: LazyObject, RFC850Formattable {
            var date: NSDate?   { return try? dateFor(#function) }
        }

        let object = Object(dictionary: ["date": "Sunday, 24-Apr-16 14:42:42 UTC"])
        guard let date = object.date else {
            XCTFail("Formatter failed to parse string.")
            return
        }
        XCTAssertTrue(date.dateMatches())
    }

}

// MARK: - NSDate Helpers

private extension NSDate {

    func dateMatches(year: Int = 2016, month: Int = 4, day: Int = 24, hour: Int = 14, minute: Int = 42, second: Int = 42, millisecond: Int? = nil) -> Bool {
        guard dateYearMatches(year) else {
            XCTFail("Year component does not match")
            return false
        }
        guard dateMonthMatches(month) else {
             XCTFail("Month component does not match")
            return false
        }
        guard dateDayMatches(day) else {
             XCTFail("Day component does not match")
            return false
        }
        guard dateHourMatches(hour) else {
             XCTFail("Hour component does not match")
            return false
        }
        guard dateMinuteMatches(minute) else {
             XCTFail("Minute component does not match")
            return false
        }
        guard dateSecondMatches(second) else {
             XCTFail("Second component does not match")
            return false
        }
        if let millisecond = millisecond {
            guard dateMillisecondMatches(millisecond) else {
                 XCTFail("Millisecond component does not match")
                return false
            }
        }

        return true
    }

    func dateYearMatches(year: Int) -> Bool {
        let component = dateComponentFor(self, component: .Year)
        return component.year == year
    }

    func dateMonthMatches(month: Int) -> Bool {
        let component = dateComponentFor(self, component: .Month)
        return component.month == month
    }

    func dateDayMatches(day: Int) -> Bool {
        let component = dateComponentFor(self, component: .Day)
        return component.day == day
    }

    func dateHourMatches(hour: Int) -> Bool {
        let component = dateComponentFor(self, component: .Hour)
        return component.hour == hour
    }

    func dateMinuteMatches(minute: Int) -> Bool {
        let component = dateComponentFor(self, component: .Minute)
        return component.minute == minute
    }

    func dateSecondMatches(second: Int) -> Bool {
        let component = dateComponentFor(self, component: .Second)
        return component.second == second
    }

    func dateMillisecondMatches(millisecond: Int) -> Bool {
        // Only compare the last 3 digits
        let milliseconds = Int((self.timeIntervalSince1970 * 1000) % 1000)
        return milliseconds == millisecond
    }

    func dateComponentFor(date: NSDate, component: NSCalendarUnit) -> NSDateComponents {
        let utcCalendar = NSCalendar.currentCalendar()
        utcCalendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return utcCalendar.components(component, fromDate: date)
    }

}