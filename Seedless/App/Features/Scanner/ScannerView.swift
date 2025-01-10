//
//  ScannerView.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 08.01.2025.
//

import SwiftUI
import VisionKit

struct ScannerView: View {

    @Bindable var viewModel: ScannerViewModel
    @State private  var isShowingScanner: Bool = true
    
    var body: some View {
        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
            ZStack(alignment: .bottom) {
                QRScannerRepresentable(
                    shouldStartScanning: $isShowingScanner,
                    scannedText: $viewModel.scannedText,
                    dataToScanFor: [.barcode(symbologies: [])]
                )
            }
        } else if !DataScannerViewController.isSupported {
            Text(Localization.errorScanCameraNotExist)
                .multilineTextAlignment(.center)
        } else {
            Text(Localization.errorScanCameraNotAvailable)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ScannerView(viewModel: ScannerViewModel())
}
