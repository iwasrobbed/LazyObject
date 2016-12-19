//
//  NSDateFormatter+Lazy.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/24/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension DateFormatter {

    public enum Lazy {
        case iso8601, rfc3339, rfc1123, rfc850

        public func toFormatter() -> DateFormatter {
            switch self {
            case .iso8601:
                return LazyFormatterCache.iso8601
            case .rfc3339:
                return LazyFormatterCache.rfc3339
            case .rfc1123:
                return LazyFormatterCache.rfc1123
            case .rfc850:
                return LazyFormatterCache.rfc850
            }
        }

        public func toString() -> String {
            switch self {
            case .iso8601:
                return "ISO 8601"
            case .rfc3339:
                return "RFC 3339"
            case .rfc1123:
                return "RFC 1123"
            case .rfc850:
                return "RFC 850"
            }
        }

        /**
         Creates a formatter for use with date string conversions

         - parameter string: The format string to parse the date with

         - returns: An `NSDateFormatter` with UTC timezone and `en_US_POSIX` locale.
         */
        public static func formatterFrom(_ string: String) -> DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = string
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            return formatter
        }
    }

    fileprivate struct LazyFormatterCache {

        // Note: Epoch (Unix) timestamps are handled directly in convertibles, not as a formatter

        /**
         E.g. 2016-04-24T14:42:42.424Z
         */
        static let iso8601: DateFormatter = {
            return DateFormatter.Lazy.formatterFrom("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        }()

        /**
         E.g. 2016-04-24T14:42:42Z
         */
        static let rfc3339: DateFormatter = {
            return DateFormatter.Lazy.formatterFrom("yyyy-MM-dd'T'HH:mm:ss'Z'")
        }()

        /**
         E.g. Sun, 24 Apr 2016 14:42:42 +0000
         */
        static let rfc1123: DateFormatter = {
            return DateFormatter.Lazy.formatterFrom("EEE, dd MMM yyyy HH:mm:ss zzz")
        }()

        /**
         E.g. Sunday, 24-Apr-16 14:42:42 UTC
         */
        static let rfc850: DateFormatter = {
            return DateFormatter.Lazy.formatterFrom("EEEE, dd-MMM-yy HH:mm:ss zzz")
        }()
        
    }
    
}
