//
//  SeedlessTests.swift
//  SeedlessTests
//
//  Created by Aleksei Pichukov on 28.12.2024.
//

import Testing
@testable import Seedless

class SeedlessTests {

    // MARK: - Properties
    private var seedPhraseService: SeedPhraseService!
    private let wordList = WordList.english
    private let valid12Words = ["breeze", "jelly", "anchor", "library", "midnight", "hammer",
                                "ginger", "window", "tackle", "coin", "meadow", "protect"]
    private let valid24Words = ["breeze", "jelly", "anchor", "library", "midnight", "hammer",
                                "ginger", "window", "tackle", "coin", "meadow", "protect",
                                "abandon", "ability", "abstract", "absent", "about", "absurd",
                                "abuse", "above", "absorb", "abstract", "absent", "absurd"]

    // MARK: - Setup and Teardown

    init() throws {
        seedPhraseService = SeedPhraseService()
    }

    deinit {
        seedPhraseService = nil
    }

    // MARK: - Tests

    @Test
    func testEncodeDecodeCycle() async throws {
        // Test encoding
        let encoded = seedPhraseService.encodeSeedWords(valid12Words, wordList: wordList)
        #expect(encoded != nil, "Encoding failed, returned nil.")
        
        // Test decoding
        if let encoded = encoded {
            let decoded = seedPhraseService.decodeSeedWords(encoded, wordList: wordList)
            #expect(decoded != nil, "Decoding failed, returned nil.")
            #expect(decoded == valid12Words, "Decoded words do not match the original seed words.")
        }
    }

    @Test
    func testEncodeDecodeCycle24Words() async throws {
        // Test encoding
        let encoded = seedPhraseService.encodeSeedWords(valid24Words, wordList: wordList)
        #expect(encoded != nil, "Encoding failed, returned nil.")
        
        // Test decoding
        if let encoded = encoded {
            let decoded = seedPhraseService.decodeSeedWords(encoded, wordList: wordList)
            #expect(decoded != nil, "Decoding failed, returned nil.")
            #expect(decoded == valid24Words, "Decoded words do not match the original seed words.")
        }
    }

    @Test
    func testInvalidSeedWords() async throws {
        let invalidSeedWords = ["breeze", "invalidWord", "library"]

        // Test encoding with invalid seed words
        let encoded = seedPhraseService.encodeSeedWords(invalidSeedWords, wordList: wordList)
        #expect(encoded == nil, "Encoding should fail when seed words contain invalid entries.")
    }

    @Test
    func testInvalidEncodedString() async throws {
        // Test decoding with an invalid encoded string
        let invalidEncodedString = ""
        let decoded = seedPhraseService.decodeSeedWords(invalidEncodedString, wordList: wordList)
        #expect(decoded == nil, "Decoding should fail for an invalid Base64 string.")
    }

    @Test
    func testEdgeCases() async throws {
        let emptySeedWords: [String] = []

        // Test encoding with empty seed words
        let encoded = seedPhraseService.encodeSeedWords(emptySeedWords, wordList: wordList)
        #expect(encoded == nil || encoded == "", "Encoding empty seed words should return nil or an empty string.")

        // Test decoding an empty string
        let decoded = seedPhraseService.decodeSeedWords("", wordList: wordList)
        #expect(decoded == nil || decoded!.isEmpty, "Decoding an empty string should return nil or an empty array.")
    }
}
