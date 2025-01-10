//
//  SeedEntryView.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 28.12.2024.
//

import SwiftUI
import Combine

struct SeedEntryView: View {

    @State private var viewModel = SeedEntryViewModel()
    @FocusState private var focusedField: Int?
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @State private var checkForSuggestion = true
    @State private var isHidden: Bool = false

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ScrollViewReader { proxy in
                VStack {
                    ScrollView {
                        segmentedControl
                            .padding(Spacing.padding_2)
                        grid(proxy: proxy)
                            .padding(.horizontal, Spacing.padding_2)
                            .if(isHidden) { content in
                                content.blur(radius: 15)
                            }
                    }
                    Spacer()
                    buttons
                        .padding(.horizontal, Spacing.padding_2)
                        .padding(.vertical, focusedField != nil ? 0 : Spacing.padding_2)
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
                .navigationTitle(Localization.seedEntryTitle)
                .navigationDestination(for: SeedPhraseDestination.self) { destination in
                    switch destination {
                    case .seedInfo(let viewModel):
                        SeedInfoView(viewModel: viewModel).accentColor(Color.tintAccent)
                    }
                }
                .background(Color.surfaceBackground.ignoresSafeArea())
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .background || newValue == .inactive {
                        withAnimation {
                            isHidden = true
                        }
                    } else if newValue == .active {
                        viewModel.checkClipbaord()
                        withAnimation {
                            isHidden = false
                        }
                    }
                }
                .keyboardToolbar {
                    wordSuggestions(proxy: proxy)
                        .frame(height: Constants.toolbarHeight)
                        .padding(.horizontal, Spacing.padding_2)
                }
                .toastMessageDS(
                    message: viewModel.toastMessage,
                    isPresented: $viewModel.toastMessagePresented,
                    color: .solidDanger,
                    duration: 5
                )
            }
        }
    }

    private var buttons: some View {
        VStack(spacing: Spacing.padding_2) {
            if viewModel.pasteAvailable {
                ButtonDS(Localization.buttonPaste, style: .outlined) {
                    viewModel.pasteFromClipboard()
                }
            }
            ButtonDS(Localization.buttonEncode) {
                viewModel.transformAction()
            }
            .disabled(!viewModel.transformEnabled)
        }
    }

    private var segmentedControl: some View {
        Picker(Localization.seedEntrySegmentTitle, selection: $viewModel.selectedCount) {
            Text(Localization.seedEntrySegment12Words).tag(12)
            Text(Localization.seedEntrySegment24Words).tag(24)
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    private func grid(proxy: ScrollViewProxy) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.padding_2) {
            ForEach(0..<viewModel.selectedCount, id: \.self) { index in
                TextInputDS(
                    placeholder: "\(Localization.seedEntryWord) \(index + 1)",
                    text: $viewModel.seedWords[index],
                    prefix: "\(index + 1)."
                )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: index)
                    .id(index)
                    .onChange(of: viewModel.seedWords[index]) { _, newValue in
                        if checkForSuggestion {
                            viewModel.updateSuggestedWord(for: newValue)
                        } else {
                            checkForSuggestion = true
                        }
                    }
            }
        }
    }

    private func wordSuggestions(proxy: ScrollViewProxy) -> some View {
        HStack {
            if let suggestedWord = viewModel.suggestedWord {
                Button(action: {
                    checkForSuggestion = false
                    viewModel.applySuggestedWord(at: focusedField ?? 0)
                    moveToNextField(proxy: proxy)
                    viewModel.suggestedWord = nil
                }) {
                    Text(suggestedWord)
                        .typography(.body2, color: .tintOnAccent)
                        .padding(.horizontal, Spacing.padding_1_2_5)
                        .padding(.vertical, Spacing.padding_0_5)
                        .background(
                            Capsule()
                                .fill(Color.tintAccent)
                        )
                }
            }
            Spacer()
            Button(Localization.buttonNext) {
                moveToNextField(proxy: proxy)
            }
            .disabled(focusedField == nil || focusedField == viewModel.selectedCount - 1)
        }
    }

    private func moveToNextField(proxy: ScrollViewProxy) {
        guard let currentIndex = focusedField else { return }
        let nextIndex = currentIndex + 1
        if nextIndex < viewModel.selectedCount {
            focusedField = nextIndex
            withAnimation {
                proxy.scrollTo(nextIndex, anchor: .center)
            }
        } else {
            focusedField = nil
        }
    }
}

private extension SeedEntryView {
    enum Constants {
        static let toolbarHeight: CGFloat = 32
    }
}

#Preview {
    NavigationStack {
        SeedEntryView()
    }
}
