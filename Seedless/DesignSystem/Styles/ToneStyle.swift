//
//  ToneStyle.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 28.12.2024.
//

import SwiftUI

struct ToneStyle: ViewModifier {

    enum Style {
        case idle
        case disabled
    }

    let style: Style

    init(style: Style) {
        self.style = style
    }

    func body(content: Content) -> some View {
        switch style {
        case .idle:
            return content
                .opacity(1)
        case .disabled:
            return content
                .opacity(0.5)
        }
    }
}

extension View {

    func toneStyle(_ style: ToneStyle.Style) -> some View {
        return self.modifier(ToneStyle(style: style))
    }
}
