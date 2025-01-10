//
//  SeedPhraseDestination.swift
//  Seedless
//
//  Created by Aleksei Pichukov on 08.01.2025.
//

enum SeedPhraseDestination {
    case seedInfo(SeedInfoViewModel)
}

extension SeedPhraseDestination: Equatable {

    static func == (
        lhs: SeedPhraseDestination,
        rhs: SeedPhraseDestination
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.seedInfo(lhsViewModel), .seedInfo(rhsViewModel)):
            return lhsViewModel.id == rhsViewModel.id
        }
    }
}

extension SeedPhraseDestination: Hashable {

    func hash(into hasher: inout Hasher) {
        switch self {
        case let .seedInfo(viewModel):
            hasher.combine(viewModel.id)
        }
    }
}
