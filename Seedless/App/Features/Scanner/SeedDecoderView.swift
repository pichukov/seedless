//
//  SeedDecoderView.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 08.01.2025.
//

import SwiftUI

struct SeedDecoderView: View {

    @State private var viewModel: ScannerViewModel = ScannerViewModel()
    @State private var selectedSegment: SegmentedTab = .qrCode
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing: .zero) {
                segmentedControl
                    .padding(Spacing.padding_2)

                switch selectedSegment {
                case .qrCode:
                    qrCodeContent
                        .padding(Spacing.padding_2)
                case .textInput:
                    textInputContent
                        .padding(Spacing.padding_2)
                }

                Spacer()

                ButtonDS(Localization.buttonDecode) {
                    viewModel.decodeAction()
                }
                .disabled(viewModel.decodedString.isEmpty)
                .padding(Spacing.padding_2)
            }
            .background(Color.surfaceBackground.ignoresSafeArea())
            .navigationTitle(Localization.decoderTitle)
            .navigationDestination(for: SeedPhraseDestination.self) { destination in
                switch destination {
                case .seedInfo(let viewModel):
                    SeedInfoView(viewModel: viewModel).accentColor(Color.tintAccent)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.body)
                    }
                }
            }
        }
    }

    private var segmentedControl: some View {
        Picker(Localization.decoderSegmentTitle, selection: $selectedSegment) {
            Text(Localization.decoderSegmentQR).tag(SegmentedTab.qrCode)
            Text(Localization.decoderSegmentText).tag(SegmentedTab.textInput)
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    private var qrCodeContent: some View {
        VStack(spacing: Spacing.padding_2) {
            ScannerView(viewModel: viewModel)
                .clipShape(RoundedRectangle(cornerRadius: Radius.radius_6))
            Text(Localization.decoderQRCaption)
                .typography(.caption)
                .multilineTextAlignment(.center)
                .lineSpacing(Spacing.padding_0_5)
            if !viewModel.decodedString.isEmpty {
                encodedSeedPhraseWidget
            }
        }
    }

    private var textInputContent: some View {
        VStack(spacing: Spacing.padding_2) {
            TextInputDS(placeholder: Localization.decoderInputPlaceholder, text: $viewModel.scannedText)
                .textInputAutocapitalization(.never)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
            Text(Localization.decoderInputCaption)
                .typography(.caption)
                .multilineTextAlignment(.center)
                .lineSpacing(Spacing.padding_0_5)
            if !viewModel.decodedString.isEmpty {
                encodedSeedPhraseWidget
            }
        }
    }

    private var encodedSeedPhraseWidget: some View {
        WidgetDS {
            VStack(alignment: .center, spacing: Spacing.padding_3) {
                HStack {
                    Image(systemName: "lock.square.stack")
                        .resizable()
                        .frame(
                            width: Constants.iconWidth,
                            height: Constants.iconHeight
                        )
                        .foregroundStyle(Color.solidWarning)
                    Text(Localization.decoderWidgetTitle)
                        .typography(.subtitle)
                    Spacer()
                }
                Text(viewModel.decodedString)
                    .typography(.headline3)
            }
        }
    }
}

private extension SeedDecoderView {

    enum SegmentedTab: Hashable {
        case qrCode
        case textInput
    }

    enum Constants {
        static let iconWidth: CGFloat = 22
        static let iconHeight: CGFloat = 24
    }
}

#Preview {
    SeedDecoderView()
}
