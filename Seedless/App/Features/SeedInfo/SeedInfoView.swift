//
//  SeedInfoView.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 07.01.2025.
//

import SwiftUI

struct SeedInfoView: View {

    @State var viewModel: SeedInfoViewModel

    @Environment(\.scenePhase) private var scenePhase
    @State private var isHidden = false
    @State private var toastMessagePresented = false
    @State private var toastMessage: String = ""
    @State private var toastColor: Color = .solidInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(Localization.seedInfoDescription)
                    .typography(.body1)
                    .lineSpacing(Spacing.padding_0_5)
                    .padding(Spacing.padding_2)
                VStack(spacing: Spacing.padding_2) {
                    seedPhraseWidget
                    encodedSeedPhraseWidget
                    qrCodeWidget
                }
                .padding(.horizontal, Spacing.padding_2)
                .padding(.bottom, Spacing.padding_2)
            }
        }
        .navigationTitle(Localization.seedInfoTitle)
        .background(Color.surfaceBackground.ignoresSafeArea())
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .background || newValue == .inactive {
                withAnimation {
                    isHidden = true
                }
            } else if newValue == .active {
                withAnimation {
                    isHidden = false
                }
            }
        }
        .toastMessageDS(
            message: toastMessage,
            isPresented: $toastMessagePresented,
            color: toastColor
        )
    }

    // MARK: Widgets

    private var seedPhraseWidget: some View {
        WidgetDS {
            VStack(alignment: .center, spacing: Spacing.padding_3) {
                widgetTitle(
                    title: Localization.seedInfoWidgetSeedTitle,
                    iconName: "square.stack",
                    iconColor: Color.solidSuccess
                )
                seedWordsGrid
                .if(isHidden) { content in
                    content.blur(radius: 15)
                }
                ButtonDS(
                    Localization.buttonCopy,
                    style: .outlined,
                    isSmall: true,
                    icon: .leading(Image(systemName: "document.on.document"))
                ) {
                    viewModel.copyWords()
                    toastMessage = Localization.seedInfoMessageCopied
                    toastColor = .solidSuccess
                    toastMessagePresented = true
                }
            }
        }
    }

    private var seedWordsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: Spacing.padding_2
        ) {
            ForEach(0..<viewModel.words.count, id: \.self) { index in
                HStack(spacing: Spacing.padding_0_2_5) {
                    Text("\(index + 1).")
                        .typography(.body2, color: .tintSecondary)
                        .frame(width: 22)
                    Text("\(viewModel.words[index])")
                        .typography(.body1)
                    Spacer()
                }
            }
        }
    }

    private var encodedSeedPhraseWidget: some View {
        WidgetDS {
            VStack(alignment: .center, spacing: Spacing.padding_3) {
                widgetTitle(
                    title: Localization.seedInfoWidgetEncodedTitle,
                    iconName: "lock.square.stack",
                    iconColor: Color.solidWarning
                )
                Text(viewModel.decodedString)
                    .typography(.headline3)
                ButtonDS(
                    Localization.buttonCopy,
                    style: .outlined,
                    isSmall: true,
                    icon: .leading(Image(systemName: "document.on.document"))
                ) {
                    viewModel.copyDecodedString()
                    toastMessage = Localization.seedInfoMessageEncodedCopied
                    toastColor = .solidWarning
                    toastMessagePresented = true
                }
            }
        }
    }

    private var qrCodeWidget: some View {
        WidgetDS {
            VStack(alignment: .center, spacing: Spacing.padding_3) {
                widgetTitle(
                    title: Localization.seedInfoWidgetQRTitle,
                    iconName: "qrcode",
                    iconColor: Color.solidDanger
                )
                Image(uiImage: viewModel.qrCodeImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: Constants.qrImageSize,
                        height: Constants.qrImageSize
                    )
                ShareLinkDS(
                    image: viewModel.qrCodeImage,
                    title: Localization.seedInfoWidgetQRShareTitle,
                    buttonText: Localization.buttonShare
                )
            }
        }
    }

    private func widgetTitle(
        title: String,
        iconName: String,
        iconColor: Color
    ) -> some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .frame(
                    width: Constants.iconSize,
                    height: Constants.iconSize
                )
                .foregroundStyle(iconColor)
            Text(title)
                .typography(.subtitle)
            Spacer()
        }
    }
}

// MARK: Constants

private extension SeedInfoView {
    enum Constants {
        static let iconSize: CGFloat = 24
        static let qrImageSize: CGFloat = 200
    }
}

#Preview {
    NavigationStack {
        SeedInfoView(
            viewModel: SeedInfoViewModel(
                words: [
                    "breeze",
                    "jelly",
                    "anchor",
                    "library",
                    "midnight",
                    "hammer",
                    "ginger",
                    "window",
                    "tackle",
                    "coin",
                    "meadow",
                    "protect"
                ]
            )
        )
    }
}
