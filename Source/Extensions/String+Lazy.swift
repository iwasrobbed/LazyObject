//
//  String+Lazy.swift
//  LazyObject
//
//  Created by Rob Phillips on 3/27/17.
//  Copyright © 2017 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension String {
    
    func toBool() -> Bool {
        switch self.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
}
