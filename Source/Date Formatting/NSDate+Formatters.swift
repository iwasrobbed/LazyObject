//
//  LazyConvertible+NSDate.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/24/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension NSDate {

    public enum LazyFormatter {
        case iso8601, rfc3339, rfc1123, rfc850

        func toFormatter() -> NSDateFormatter {
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

        func toString() -> String {
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
    }

    private struct LazyFormatterCache {

        // Note: Epoch (Unix) timestamps are handled directly in convertibles, not as a formatter

        static let iso8601: NSDateFormatter = {
            return NSDateFormatter.Lazy.formatterFrom("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        }()

        static let rfc3339: NSDateFormatter = {
            return NSDateFormatter.Lazy.formatterFrom("yyyy-MM-dd'T'HH:mm:ss'Z'")
        }()

        static let rfc1123: NSDateFormatter = {
            return NSDateFormatter.Lazy.formatterFrom("EEE, dd MMM yyyy HH:mm:ss zzz")
        }()

        static let rfc850: NSDateFormatter = {
            return NSDateFormatter.Lazy.formatterFrom("EEEE, dd-MMM-yy HH:mm:ss zzz")
        }()
        
    }
}
