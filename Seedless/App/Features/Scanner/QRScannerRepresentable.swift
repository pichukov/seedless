//
//  QRScannerRepresentable.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 08.01.2025.
//

import SwiftUI
import VisionKit

struct QRScannerRepresentable: UIViewControllerRepresentable {

    @Binding var shouldStartScanning: Bool
    @Binding var scannedText: String
    var dataToScanFor: Set<DataScannerViewController.RecognizedDataType>

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
       var parent: QRScannerRepresentable

       init(_ parent: QRScannerRepresentable) {
           self.parent = parent
       }

        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didAdd addedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {
            for item in addedItems {
                switch item {
                case .text(let text):
                    parent.scannedText = text.transcript
                case .barcode(let barcode):
                    parent.scannedText = barcode.payloadStringValue ?? Localization.errorScanDecoding
                default:
                    return
                }
            }
        }
    }

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerVC = DataScannerViewController(
            recognizedDataTypes: dataToScanFor,
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )

        dataScannerVC.delegate = context.coordinator

       return dataScannerVC
    }

    func updateUIViewController(
        _ uiViewController: DataScannerViewController,
        context: Context
    ) {
       if shouldStartScanning {
           try? uiViewController.startScanning()
       } else {
           uiViewController.stopScanning()
       }
    }

    func makeCoordinator() -> Coordinator {
       Coordinator(self)
    }
}
