//
//  SeedPhraseService.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 07.01.2025.
//

import Foundation

/// A service for encoding and decoding seed phrases to and from a Base64 string representation.
class SeedPhraseService {

    /// The Base64 character set used for encoding and decoding.
    private let base64Table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    /// Encodes an array of seed words into a Base64 string using a predefined word list.
    ///
    /// This function maps each seed word to its index in the word list, converts the indices into binary format,
    /// and encodes them as a Base64 string.
    ///
    /// - Parameters:
    ///   - seedWords: The array of seed words to encode.
    ///   - wordList: A predefined list of valid words for the seed phrase.
    /// - Returns: A Base64-encoded string if the encoding succeeds, otherwise `nil`.
    ///
    /// Example usage:
    /// ```swift
    /// let seedWords = ["apple", "banana", "cherry", ...]
    /// let encoded = SeedPhraseService().encodeSeedWords(seedWords, wordList: WordList.english)
    /// ```
    func encodeSeedWords(_ seedWords: [String], wordList: [String]) -> String? {
        // Step 1: Convert each word to its index in the word list
        let indices = seedWords.compactMap { wordList.firstIndex(of: $0) }
        guard indices.count == seedWords.count else {
            return nil
        }

        // Step 2: Convert indices to binary strings and concatenate
        let binaryString = indices.map { String($0, radix: 2).leftPad(toLength: 11, withPad: "0") }.joined()

        // Step 3: Break binary string into 6-bit chunks
        let chunks = stride(from: 0, to: binaryString.count, by: 6).map {
            binaryString.substring(from: $0, to: min($0 + 6, binaryString.count))
        }

        // Step 4: Convert each 6-bit chunk to a decimal value and map to Base64 character
        let base64String = chunks.compactMap { chunk -> String? in
            if let value = Int(chunk, radix: 2) {
                let char = base64Table[base64Table.index(base64Table.startIndex, offsetBy: value)]
                return String(char)
            }
            return nil
        }.joined()

        return base64String
    }

    /// Decodes a Base64 string back into an array of seed words using a predefined word list.
    ///
    /// This function converts the Base64 string into binary representation, maps the binary data to
    /// word indices, and retrieves the corresponding seed words from the word list.
    ///
    /// - Parameters:
    ///   - encodedString: The Base64-encoded string to decode.
    ///   - wordList: A predefined list of valid words for the seed phrase.
    /// - Returns: An array of seed words if decoding succeeds, otherwise `nil`.
    ///
    /// Example usage:
    /// ```swift
    /// let encodedString = "ABCD1234"
    /// let decoded = SeedPhraseService().decodeSeedWords(encodedString, wordList: WordList.english)
    /// ```
    func decodeSeedWords(_ encodedString: String, wordList: [String]) -> [String]? {
        // Step 1: Convert each Base64 character to its 6-bit binary representation
        let binaryString = encodedString.compactMap { char -> String? in
            if let index = base64Table.firstIndex(of: char) {
                let intIndex = base64Table.distance(from: base64Table.startIndex, to: index)
                return String(intIndex, radix: 2).leftPad(toLength: 6, withPad: "0")
            }
            return nil
        }.joined()

        // Step 2: Break binary string into 11-bit chunks
        let chunks = stride(from: 0, to: binaryString.count, by: 11).compactMap {
            binaryString.substring(from: $0, to: min($0 + 11, binaryString.count))
        }

        // Step 3: Convert each 11-bit binary chunk to an integer and map to seed words
        let indices = chunks.compactMap { Int($0, radix: 2) }
        guard indices.allSatisfy({ $0 < wordList.count }) else {
            return nil
        }
        guard indices.count > 11 else {
            return nil
        }

        return indices.map { wordList[$0] }
    }

}

// MARK: - String Extensions

private extension String {
    /// Pads the string on the left to match the specified length.
    ///
    /// - Parameters:
    ///   - toLength: The desired length of the string after padding.
    ///   - withPad: The padding character to use.
    /// - Returns: A new string padded on the left.
    func leftPad(toLength: Int, withPad pad: String) -> String {
        if self.count < toLength {
            return String(repeating: pad, count: toLength - self.count) + self
        }
        return self
    }

    /// Extracts a substring between two indices.
    ///
    /// - Parameters:
    ///   - start: The starting index of the substring.
    ///   - end: The ending index of the substring (exclusive).
    /// - Returns: A substring from the specified range.
    func substring(from start: Int, to end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        return String(self[startIndex..<endIndex])
    }
}
