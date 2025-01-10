//
//  ScannerViewModel.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 08.01.2025.
//

import SwiftUI
import Observation

@Observable
class ScannerViewModel {

    var scannedText: String = "" {
        didSet {
            decode(value: scannedText)
        }
    }
    var decodedString: String = ""
    private var seedPhraseService = SeedPhraseService()
    var path: [SeedPhraseDestination] = []

    func decodeAction() {
        guard
            !decodedString.isEmpty,
            let words = seedPhraseService.decodeSeedWords(
                decodedString,
                wordList: WordList.english
            ),
            words.count % 12 == 0
        else {
            return
        }
        path.append(
            .seedInfo(SeedInfoViewModel(words: words))
        )
    }

    private func decode(value: String) {
        guard
            let words = seedPhraseService.decodeSeedWords(
                value,
                wordList: WordList.english
            ),
            words.count % 12 == 0,
            decodedString != value
        else {
            return
        }
        decodedString = value
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}
