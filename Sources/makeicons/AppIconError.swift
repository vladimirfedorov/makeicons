//
//  AppIconError.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation

enum AppIconError: Error {
    case decodingFailed
    var localizedDescription: String {
        switch self {
        case .decodingFailed: return "JSON decoding failed"
        }
    }
}
