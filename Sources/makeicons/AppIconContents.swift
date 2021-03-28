//
//  AppIconContents.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation
class AppIconContents {
    /// `images` element from Contents.json.
    /// There may be another elements, the app shouldn't change them.
    private struct IconContents: Codable {
        let images: [IconElement]
    }
    
    /// This key in JSON file contains all images for Xcode.
    private let imagesKey = "images"
    
    /// Stores decoded "images" content
    private let contentImages: IconContents
    
    /// Contents.json data.
    private var contentsJSON: [String: Any] = [:]
    
    /// Initializes `AppIconContents` with `Contents.json` data.
    /// - Parameter data: `Contents.json` file data.
    /// - Throws: `JSONSerialization` and `JSONDecoder` errors.
    init(data: Data) throws {
        guard let decodedJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw AppIconError.decodingFailed
        }
        contentsJSON = decodedJSON
        contentImages = try JSONDecoder().decode(IconContents.self, from: data)
    }
    
    /// Serialized `contentsJSON` data. This data contains formatted JSON content.
    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: contentsJSON, options: .prettyPrinted)
    }
    
    /// Icon elements from "images"
    var iconElements: [IconElement] {
        get {
            contentImages.images
        }
        set {
            contentsJSON[imagesKey] = try? newValue.asJSON()
        }
    }
}
