//
//  CategorizationHomeViewModel.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/10/2023.
//

import Combine

@MainActor
class CategorizationHomeViewModel: ObservableObject {

    private let teamsService: TeamServiceProtocol

    @Published var userTeams: [Team] = []
    @Published var error: Error?
    @Published var isLoading = false

    @Published var selectedTeam: DropdownOption?

    init(teamsService: TeamServiceProtocol) {
        self.teamsService = teamsService
    }

    func selectTeam(option: DropdownOption) {
        selectedTeam = option
    }

    func fetchMyTeams() async {
        isLoading = true
        let result = await teamsService.getUserTeams()
        isLoading = false
        if let error = result.1 {
            self.error = error
        } else if let userTeams = result.0 {
            self.userTeams = userTeams
            if let team = userTeams.first {
                self.selectedTeam = team.toDropdownOption()
            }
        }
    }
}
