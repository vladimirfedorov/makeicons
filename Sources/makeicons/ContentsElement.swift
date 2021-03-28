//
//  ContentsElement.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation

/// `Contents.json` `images` element protocol.
protocol ContentsElement: Codable {
    var idiom: String { get }
    var scale: String { get }
    var size: String { get }
    var filename: String? { get set }
}
