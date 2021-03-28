//
//  NSSize+extensions.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation

extension NSSize {
    /// Multiplies `width` and `height` by the right operand value
    static func * (left: NSSize, right: CGFloat) -> NSSize {
        return NSSize(width: left.width * right, height: left.height * right)
    }
}
