//
//  SeedEntryViewModel.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 03.01.2025.
//

import SwiftUI
import Observation

@Observable
class SeedEntryViewModel {

    var selectedCount: Int = 12 {
        didSet {
            adjustSeedWords()
        }
    }
    var seedWords: [String] = Array(repeating: "", count: 24)
    var clipboardText: String? = nil
    var pasteAvailable: Bool = false
    var suggestedWord: String?
    var transformEnabled: Bool {
        if selectedCount == 12 {
            return seedWords.filter { !$0.isEmpty }.count == 12
        } else if selectedCount == 24 {
            return seedWords.filter { !$0.isEmpty }.count == 24
        } else {
            return false
        }
    }
    var path: [SeedPhraseDestination] = []
    var toastMessagePresented = false
    var toastMessage: String = ""

    init() {
        checkClipbaord()
    }

    func checkClipbaord() {
        guard UIPasteboard.general.hasStrings else { return }
        pasteAvailable = true
    }

    func transformAction() {
        guard seedWords.count % 12 == 0 else { return }
        path.append(
            .seedInfo(
                SeedInfoViewModel(
                    words: Array(seedWords.prefix(selectedCount))
                )
            )
        )
    }

    func pasteFromClipboard() {
        defer {
            UIPasteboard.general.string = nil
            pasteAvailable = false
        }
        guard let text = UIPasteboard.general.string else {
            toastMessage = Localization.errorClipboardNoText
            toastMessagePresented = true
            return
        }
        let words = text.split(separator: " ").map { String($0) }
        guard words.count == 12 || words.count == 24 else {
            toastMessage = Localization.errorClipboardIncorrectSeed
            toastMessagePresented = true
            return
        }
        selectedCount = words.count
        seedWords = words + Array(repeating: "", count: 24 - words.count)
    }

    func updateSuggestedWord(for input: String) {
        guard !input.isEmpty else {
            suggestedWord = nil
            return
        }
        suggestedWord = WordList.english.first(where: { $0.hasPrefix(input.lowercased()) })
    }

    func applySuggestedWord(at index: Int) {
        guard let suggestion = suggestedWord else { return }
        seedWords[index] = suggestion
        suggestedWord = nil
    }

    private func adjustSeedWords() {
        if selectedCount == 12 {
            seedWords = Array(seedWords.prefix(12)) + Array(repeating: "", count: 12)
        } else if selectedCount == 24 {
            seedWords = seedWords + Array(repeating: "", count: max(0, 24 - seedWords.count))
        }
    }
}
