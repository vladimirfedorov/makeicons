//
//  Application.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Cocoa

class Application {
    static let shared = Application()
    
    /// Main function of the application.
    /// - Parameters:
    ///   - imagePath: Path to `.png` image.
    ///   - projectPath: Path `AppIcon.appiconset` folder; can be just a path to Xcode project if it contains one `AppIcon.appiconset` folder.
    ///   - idiom: Optional idiom to apply the image to.
    func run(imagePath: String, projectPath: String, idiom: String?) {
        let imageUrl = URL(fileURLWithPath: imagePath)
        if !imageUrl.fileExists {
            print("Image file \(imagePath) doesn't exist")
            return
        }
        let projectUrl = URL(fileURLWithPath: projectPath)
        if !projectUrl.folderExists {
            print("Folder \(projectPath) doesn't exist")
            return
        }
        do {
            let appIconUrls = try self.appIconUrls(startingUrl: projectUrl)
            if appIconUrls.count > 1 {
                print("More than one \(appIconFolderName) found, specify one of the paths below:")
                for url in appIconUrls {
                    print("- \(url.deletingLastPathComponent().path)")
                }
                return
            }
            guard let iconUrl = appIconUrls.first else {
                print("No \(appIconFolderName) found.")
                return
            }
            guard let image = NSImage(contentsOf: imageUrl) else {
                print("Error opening image \(imageUrl.path)")
                return
            }
            let count = try setIcon(image: image, applicationIconURL: iconUrl, idiom: idiom)
            print("\(count) icon images updated.")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    /// Prints help text.
    func printHelp() {
        print(helpString)
    }
    
    /// Help for the app.
    private let helpString = """
    makeicons - create icons for Xcode projects.
    Usage:
    makeicons <image> <project> [-i <idiom>]
        image:      Path to .png image file to use as the app icon.
        project:    Path to Xcode project; can be a project path or AppIcon.appiconset path.
        
    Options:
        -i <idiom>: Idiom to apply the icon file to. When provided, the image will be set for all images matching this idiom.
                    For example, "-i mac" will update icons for macOS only.
    """
    
    /// `AppIcon.appiconseet` folder name
    private let appIconFolderName = "AppIcon.appiconset"
    
    /// Looks for `AppIcon.appiconset` within the provider folder URL and returns all found icon folders.
    /// - Parameters:
    ///   - startingUrl: `URL` to start from.
    ///   - urls: `URL`s found on previous iterations.
    /// - Throws: `FileManager` errors.
    /// - Returns: Array of icon folder `URL`s.
    private func appIconUrls(startingUrl: URL, urls: [URL]? = []) throws -> [URL] {
        let fm = FileManager()
        var urls: [URL] = urls ?? []
        if startingUrl.lastPathComponent == appIconFolderName {
            urls.append(startingUrl)
            return urls
        } else if fm.fileExists(atPath: startingUrl.appendingPathComponent(appIconFolderName).path) {
            urls.append(startingUrl.appendingPathComponent(appIconFolderName).appendingPathComponent("Contents.json"))
            return urls
        } else {
            for url in try fm.contentsOfDirectory(at: startingUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                var isDirectory: ObjCBool = false
                if fm.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                    urls = try appIconUrls(startingUrl: url, urls: urls)
                }
            }
        }
        return urls
    }
    
    /// Sets icon image to specified application icon set.
    /// - Parameters:
    ///   - image: Image for the icon.
    ///   - applicationIconURL: `AppIcon.appiconset` path.
    ///   - idiom: Icons idiom.
    /// - Throws: Errors when fails reading or writing contents of `AppIcon.appiconset`; errors when image resizing functionos fail.
    /// - Returns: Number of icons updated in `AppIcon.appiconset`.
    private func setIcon(image: NSImage, applicationIconURL: URL, idiom: String? = nil) throws -> Int {
        var countItemsChanged = 0
        let applicationIconFolder = applicationIconURL.deletingLastPathComponent()
        let applicationIconData = try Data(contentsOf: applicationIconURL)
        let iconContent = try AppIconContents(data: applicationIconData)
        var iconElements = iconContent.iconElements
        for (i, element) in iconElements.enumerated() {
            if element.matches(idiom: idiom) {
                if try image.resized(for: element)?.savePng(to: applicationIconFolder.appendingPathComponent(element.constructedFilename)) != nil {
                    iconElements[i].filename = element.constructedFilename
                    countItemsChanged += 1
                }
            }
        }
        iconContent.iconElements = iconElements
        if let data = iconContent.data {
            try data.write(to: applicationIconURL)
        }
        return countItemsChanged
    }
}
