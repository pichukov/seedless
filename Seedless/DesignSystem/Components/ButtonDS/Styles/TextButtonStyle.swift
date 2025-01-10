//
//  DangerButtonStyle.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 28.12.2024.
//

import SwiftUI

struct TextButtonStyle: ButtonStyle {

    @Binding private var state: ButtonDS.State
    private let height: CGFloat

    init(_ state: Binding<ButtonDS.State> = .constant(.idle), height: CGFloat) {
        self._state = state
        self.height = height
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typography(.button, color: textColor())
            .toneStyle(toneStyle(configuration))
            .padding(.vertical, Spacing.padding_1_5)
            .padding(.horizontal, Spacing.padding_3)
            .frame(height: height)
            .contentShape(Rectangle())
            .cornerRadius(Radius.radius_3)
    }

    private func textColor() -> Color {
        switch state {
        default: return .tintAccent
        }
    }

    private func toneStyle(_ configuration: Configuration) -> ToneStyle.Style {
        switch state {
        case .idle:
            return configuration.isPressed ? .disabled : .idle
        case .disabled:
            return .disabled
        case .pressed, .loading:
            return .idle
        }
    }
}
