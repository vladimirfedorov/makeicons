//
//  Array+extensions.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation

extension Array where Element: ContentsElement {
    /// Converts array of `ContentsElement`s to array of dictionaries.
    /// - Throws: `JSONEncoder` and `JSONSerialization` errors.
    /// - Returns: Array of dictionaries.
    func asJSON() throws -> [[String: Any]] {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
    }
}
