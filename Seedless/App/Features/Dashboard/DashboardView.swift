//
//  DashboardView.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 07.01.2025.
//

import SwiftUI

struct DashboardView: View {

    @State private var showSeedPhrase = false
    @State private var showQRScanner = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(Localization.dashboardTitle)
                    .typography(.headline1)
                    .padding(Spacing.padding_2)
                    .padding(.top, Spacing.padding_2)
                Text(Localization.dashboardDescription)
                    .typography(.body1)
                    .lineSpacing(Spacing.padding_0_5)
                    .padding(.horizontal, Spacing.padding_2)
                VStack(spacing: Spacing.padding_2) {
                    widget(
                        title: Localization.dashboardWidgetEncodeTitle,
                        iconName: "lock.app.dashed",
                        description: Localization.dashboardWidgetEncodeDescription,
                        buttonText: Localization.buttonEncode
                    ) {
                        showSeedPhrase = true
                    }
                    .fullScreenCover(isPresented: $showSeedPhrase) {
                        SeedEntryView()
                            .accentColor(Color.tintAccent)
                    }
                    widget(
                        title: Localization.dashboardWidgetDecodeTitle,
                        iconName: "qrcode.viewfinder",
                        description: Localization.dashboardWidgetDecodeDescription,
                        buttonText: Localization.buttonDecode
                    ) {
                        showQRScanner = true
                    }
                    .padding(.bottom, Spacing.padding_2)
                    .fullScreenCover(isPresented: $showQRScanner) {
                        SeedDecoderView()
                            .accentColor(Color.tintAccent)
                    }
                }
                .padding(Spacing.padding_2)
                
            }
        }
        .background(Color.surfaceBackground.ignoresSafeArea())
    }

    private func widget(
        title: String,
        iconName: String,
        description: String,
        buttonText: String,
        action: @escaping () -> Void
    ) -> some View {
        WidgetDS {
            VStack(alignment: .leading, spacing: Spacing.padding_3) {
                HStack {
                    Image(systemName: iconName)
                        .resizable()
                        .frame(
                            width: Constants.imageSize,
                            height: Constants.imageSize
                        )
                        .foregroundStyle(Color.solidSuccess)
                    Text(title)
                        .typography(.subtitle)
                    Spacer()
                }
                Text(description)
                    .typography(.body1)
                    .lineSpacing(Spacing.padding_0_5)
                ButtonDS(
                    buttonText,
                    style: .contained,
                    isSmall: true,
                    action: action
                )
            }
        }
    }
}

private extension DashboardView {

    enum Constants {
        static let imageSize: CGFloat = 24
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
