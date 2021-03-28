//
//  NSImage+extensions.swift
//  
//
//  Created by Vladimir Fedorov on 27.03.2021.
//

import Cocoa

/// Error object for `NSImage`-related errors.
enum NSImageError: Error {
    case cgImageFailure
    case pngRepresentationError
    var localizedDescription: String {
        switch self {
        case .cgImageFailure: return "Low-level image error"
        case .pngRepresentationError: return "Error while creating .png output format"
        }
    }
}

extension NSImage {
    /// Writes `NSImage` data in `.png` format.
    /// - Parameter url: `URL` to save the image to.
    /// - Throws: `NSImageError`when fails to get `CGImage` or represent the image in `.png` format.
    func savePng(to url: URL) throws {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw NSImageError.cgImageFailure
        }
        let newRep = NSBitmapImageRep(cgImage: cgImage)
        newRep.size = self.size
        guard let pngData = newRep.representation(using: .png, properties: [:]) else {
            throw NSImageError.pngRepresentationError
        }
        try pngData.write(to: url)
    }
    
    /// Resizes the image to `imageRealSize` parameter of `IconElement`.
    /// - Parameter iconElement: `IconElement` with size to resize to.
    /// - Returns: Resized copy of the image.
    func resized(for iconElement: IconElement) -> NSImage? {
        return resized(to: iconElement.imageRealSize)
    }
    
    /// Resizes the image to the new size.
    /// - Parameter size: New image size.
    /// - Returns: Resized copy of the image.
    func resized(to size: NSSize) -> NSImage? {
        if let bitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) {
            bitmapRep.size = size
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
            draw(in: NSRect(x: 0, y: 0, width: size.width, height: size.height), from: .zero, operation: .copy, fraction: 1.0)
            NSGraphicsContext.restoreGraphicsState()

            let resizedImage = NSImage(size: size)
            resizedImage.addRepresentation(bitmapRep)
            return resizedImage
        }
        return nil
    }
}
