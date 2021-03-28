//
//  IconElement.swift
//  One image element in `images` array in Contents.json
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation

/// `Contents.json` `images` element
struct IconElement: ContentsElement {
    let idiom: String
    let scale: String
    let size: String
    var filename: String?
}

/// `Contents.json` `images` element utility properties
extension IconElement {
    /// File name to save resized image with.
    var constructedFilename: String {
        if scaleFactor == 1 {
            return "\(idiom)-\(size).png"
        } else {
            return "\(idiom)-\(size)@\(scale).png"
        }
    }
    /// Scale factor in numeric format.
    var scaleFactor: CGFloat {
        CGFloat(scale.doubleValue)
    }
    /// Logical image size, in points.
    var imageSize: NSSize {
        size.sizeValue
    }
    /// Real image size, in pixels.
    var imageRealSize: NSSize {
        size.sizeValue * scaleFactor
    }
    /// Checks if the element matches the provided idiom.
    /// - Parameter idiom: Icon idiom.
    /// - Returns: `true` if element idiom matches the provided idiom.
    func matches(idiom: String?) -> Bool {
        guard let idiom = idiom else {
            return true
        }
        return self.idiom.lowercased() == idiom.lowercased()
    }
}
