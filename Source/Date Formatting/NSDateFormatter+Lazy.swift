//
//  NSDateFormatter+Lazy.swift
//  LazyObject
//
//  Created by Rob Phillips on 5/24/16.
//  Copyright © 2016 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension NSDateFormatter {

    public struct Lazy {

        static func formatterFrom(string: String) -> NSDateFormatter {
            let formatter = NSDateFormatter()
            formatter.dateFormat = string
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(abbreviation: "UTC")
            return formatter
        }
        
    }
    
}