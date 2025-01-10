//
//  Localization.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 09.01.2025.
//

import Foundation

enum Localization {
    // Common
    static let buttonEncode = "button_encode".localized
    static let buttonDecode = "button_decode".localized
    static let buttonPaste = "button_paste".localized
    static let buttonCopy = "button_copy".localized
    static let buttonNext = "button_next".localized
    static let buttonShare = "button_share".localized

    // Errors
    static let errorScanDecoding = "error_scan_decoding".localized
    static let errorScanCameraNotExist = "error_scan_camera_not_exist".localized
    static let errorScanCameraNotAvailable = "error_scan_camera_not_available".localized
    static let errorClipboardNoText = "error_clipboard_no_text".localized
    static let errorClipboardIncorrectSeed = "error_clipboard_incorrect_seed".localized

    // Dashboard
    static let dashboardTitle = "dashboard_title".localized
    static let dashboardDescription = "dashboard_description".localized
    static let dashboardWidgetEncodeTitle = "dashboard_widget_encode_title".localized
    static let dashboardWidgetEncodeDescription = "dashboard_widget_encode_description".localized
    static let dashboardWidgetDecodeTitle = "dashboard_widget_decode_title".localized
    static let dashboardWidgetDecodeDescription = "dashboard_widget_decode_description".localized

    // Decoder
    static let decoderTitle = "decoder_title".localized
    static let decoderSegmentTitle = "decoder_segment_title".localized
    static let decoderSegmentQR = "decoder_segment_qr".localized
    static let decoderSegmentText = "decoder_segment_text".localized
    static let decoderQRCaption = "decoder_qr_caption".localized
    static let decoderInputPlaceholder = "decoder_input_placeholder".localized
    static let decoderInputCaption = "decoder_input_caption".localized
    static let decoderWidgetTitle = "decoder_widget_title".localized

    // Seed Entry
    static let seedEntryTitle = "seed_entry_title".localized
    static let seedEntrySegmentTitle = "seed_entry_segment_title".localized
    static let seedEntrySegment12Words = "seed_entry_segment_12_words".localized
    static let seedEntrySegment24Words = "seed_entry_segment_24_words".localized
    static let seedEntryWord = "seed_entry_word".localized

    // Seed Info
    static let seedInfoTitle = "seed_info_title".localized
    static let seedInfoDescription = "seed_info_description".localized
    static let seedInfoWidgetSeedTitle = "seed_info_widget_seed_title".localized
    static let seedInfoWidgetEncodedTitle = "seed_info_widget_encoded_title".localized
    static let seedInfoWidgetQRTitle = "seed_info_widget_qr_title".localized
    static let seedInfoWidgetQRShareTitle = "seed_info_widget_qr_share_title".localized
    static let seedInfoMessageCopied = "seed_info_message_copied".localized
    static let seedInfoMessageEncodedCopied = "seed_info_message_encoded_copied".localized
}

extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }

    func localized(_ args: [CVarArg]) -> String {
        return String(format: localized, args)
    }

    func localized(_ args: CVarArg...) -> String {
        return String(format: localized, args)
    }
}
