//
//  String+extensions.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation

extension String {
    /// `Double` value of the string, cutting off all non-numerical charactrs, or `0` if value can not be represented as `Double
    ///
    /// Example: `"2".doubleValue == 2`, `"2x".doubleValue == 2`, `"x2".doubleValue == 0`
    var doubleValue: Double {
        (self as NSString).doubleValue
    }
    /// `NSSize` value if the string, or`NSSize.zero` if value can not be decoded.
    /// 
    /// Example: `"2x2".sizeValue == NSSize(width: 2, height: 2)`, `"2".sizeValue == NSSize.zero`
    var sizeValue: NSSize {
        let values = self.split(separator: "x").map { String($0).doubleValue }
        guard values.count == 2 else {
            return .zero
        }
        return NSSize(width: values[0], height: values[1])
    }
}
