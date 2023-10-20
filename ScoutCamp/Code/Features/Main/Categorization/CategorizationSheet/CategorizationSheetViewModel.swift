//
//  CategorizationSheetViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 17/10/2023.
//

import Combine

@MainActor
class CategorizationSheetViewModel: ObservableObject {

    @Published var error: Error?
    @Published var isLoading = false

    private let team: Team

    init(team: Team) {
        self.team = team
    }

}
