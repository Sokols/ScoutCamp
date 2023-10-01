//
//  CreateEditTeamViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 01/10/2023.
//

import Combine

@MainActor
class CreateEditTeamViewModel: ObservableObject {

    private let teamsService: TeamServiceProtocol

    @Published var userTeams: [Team] = []
    @Published var error: Error?
    @Published var isLoading = false

    init(teamsService: TeamServiceProtocol) {
        self.teamsService = teamsService
    }

    
}
