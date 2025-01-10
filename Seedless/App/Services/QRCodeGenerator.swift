//
//  QRCodeGenerator.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 07.01.2025.
//

import CoreImage.CIFilterBuiltins
import UIKit

/// A utility class for generating QR code images.
class QRCodeGenerator {

    /// Generates a QR code image from a given string with a specified size.
    ///
    /// - Parameters:
    ///   - string: The input string to encode into a QR code.
    ///   - size: The desired size of the generated QR code image.
    /// - Returns: A `UIImage` containing the QR code if the generation is successful; otherwise, `nil`.
    ///
    /// Example usage:
    /// ```swift
    /// if let qrImage = QRCodeGenerator.qrCodeImage(from: "Hello, World!", size: CGSize(width: 200, height: 200)) {
    ///     // Use the QR image in your app
    /// }
    /// ```
    static func qrCodeImage(from string: String, size: CGSize) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)

        guard let outputImage = filter.outputImage else {
            return nil
        }

        let scaleX = size.width / outputImage.extent.size.width
        let scaleY = size.height / outputImage.extent.size.height

        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
