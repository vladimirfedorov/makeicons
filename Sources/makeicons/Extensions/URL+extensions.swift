//
//  File.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Foundation

extension URL {
    /// Returns `true` if the `URL` is a file and it exists, `false` otherwise.
    var fileExists: Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory) && !isDirectory.boolValue
    }
    
    /// Returns `true` if the `URL` is a folder and it exists, `false` otherwise.
    var folderExists: Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
