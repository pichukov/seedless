//
//  SeedInfoViewModel.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 07.01.2025.
//

import SwiftUI
import Observation

@Observable
class SeedInfoViewModel {

    let id = UUID()
    var words: [String] = []
    var decodedString: String = ""
    var qrCodeImage: UIImage = UIImage()

    init (words: [String]) {
        self.words = words
        encode()
        generateQrCodeImage()
    }

    func copyWords() {
        UIPasteboard.general.string = words.joined(separator: " ")
    }

    func copyDecodedString() {
        UIPasteboard.general.string = decodedString
    }

    private func generateQrCodeImage() {
        qrCodeImage = QRCodeGenerator.qrCodeImage(
            from: decodedString,
            size: .init(width: 512, height: 512)
        ) ?? UIImage(systemName: "xmark.circle") ?? UIImage()
    }

    private func encode() {
        decodedString = SeedPhraseService().encodeSeedWords(
            words,
            wordList: WordList.english
        ) ?? ""
    }
}
